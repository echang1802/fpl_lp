
# This is a base model: Do not take into account:
# - Transfers between gameweek

# --------------------------->>> Params <<<---------------------------
param gweeks := 38;

# --------------------------->>> Sets <<<---------------------------
# Players
set Players := { read "data/players_costs.dat" as "<1s>" };

# Goalkeepers
set Goalkeepers := { read "data/goalkeepers.dat" as "<1s>" };

# Defenders
set Defenders := { read "data/defenders.dat" as "<1s>" };

# Midfielders
set Midfielders := { read "data/midfielders.dat" as "<1s>" };

# Forwards
set Forwards := { read "data/forwards.dat" as "<1s>" };

# Teams
set Teams := { read "data/teams.dat" as "<1s>" };

# Gameweeks
set Gameweeks := { 1 .. gweeks };

# --------------------------->>> Data <<<---------------------------
# Predicted scores
param Score[Players*Gameweeks] := read "data/players_season_predicted_scores.dat" as "n+";

# Players costs
param Costs[Players] := read "data/players_costs.dat" as "<1s> 2n";

# Players teams
param Team[Players] := read "data/players_teams.dat" as "<1s> 2s";

# --------------------------->>> Variables <<<---------------------------
# Is the player on the team?
var y[Players] binary;

# Is the player in the line-up on gameweek j?
var x[Players*Gameweeks] binary;

# Is the player selected as captain on gameweek j?
var z[Players*Gameweeks] binary;

# --------------------------->>> Objective Function <<<---------------------------
maximize fobj: sum <p,j> in Players*Gameweeks: (Score[p,j] * x[p,j] + Score[p,j] * z[p,j]);

# --------------------------->>> Subject To: <<<---------------------------
# Total number of players selected
subto total_players:
  sum <p> in Players: y[p] == 15;


# Players by position on team
subto gkp_on_team:
  sum <p> in Goalkeepers: y[p] == 2;

subto def_on_team:
  sum <p> in Defenders: y[p] == 5;

subto med_on_team:
  sum <p> in Midfielders: y[p] == 5;

subto fwd_on_team:
  sum <p> in Forwards: y[p] == 3;


# Player on line up must be on team
subto line_up_on_team: forall <p> in Players:
  sum <j> in Gameweeks: x[p,j] <= gweeks * y[p];


# Players by position on line up
subto gkp_on_line_up: forall <j> in Gameweeks:
  sum <p> in Goalkeepers: x[p,j] == 1;
subto def_on_line_up: forall <j> in Gameweeks:
  sum <p> in Defenders: x[p,j] >= 3;

subto mid_on_line_up: forall <j> in Gameweeks:
  sum <p> in Midfielders: x[p,j] >= 2;

subto fwd_on_line_up: forall <j> in Gameweeks:
  sum <p> in Forwards: x[p,j] >= 1;


# One captain by gameweek
subto captain_on_line_up: forall <j> in Gameweeks:
  sum <p> in Players: z[p,j] == 1;


# Captain must be on line up
subto captain_by_gw: forall <p,j> in Players*Gameweeks:
  z[p,j] <= x[p,j];


# Budget
subto budget:
  sum <p> in Players: Costs[p] * y[p] <= 100;


# Team capacity
subto team_constrain: forall <t> in Teams:
  sum <p> in Players with Team[p] == t: y[p] <= 3;
