
# This is a base model: Do not take into account:
# - Transfers between gameweek

# --------------------------->>> Params <<<---------------------------
param gweeks := 38;

# --------------------------->>> Sets <<<---------------------------
# Players
set Players := { read "data/players_costs.dat" as "<1s>" };

# Positions

# Goalkeepers
set Goalkeepers := { read "data/goalkeepers.dat" as "<1s>" };

# Defenders
set Defenders := { read "data/defenders.dat" as "<1s>" };

# Midfielders
set Midfielders := { read "data/midfielders.dat" as "<1s>" };

# Forwards
set Forwards := { read "data/forwards.dat" as "<1s>" };

# Arsenal
set Arsenal := { read "data/Arsenal_players.dat" as "<1s>" };

# Aston Villa
set Aston_Villa := { read "data/Aston Villa_players.dat" as "<1s>" };

# Brentford
set Brentford := { read "data/Brentford_players.dat" as "<1s>" };

# Brighton
set Brighton := { read "data/Brighton_players.dat" as "<1s>" };

# Burnley
set Burnley := { read "data/Burnley_players.dat" as "<1s>" };

# Chelsea
set Chelsea := { read "data/Chelsea_players.dat" as "<1s>" };

# Crystal Palace
set Crystal_Palace := { read "data/Crystal Palace_players.dat" as "<1s>" };

# Everton
set Everton := { read "data/Everton_players.dat" as "<1s>" };

# Leeds
set Leeds := { read "data/Leeds_players.dat" as "<1s>" };

# Leicester
set Leicester := { read "data/Leicester_players.dat" as "<1s>" };

# Liverpool
set Liverpool := { read "data/Liverpool_players.dat" as "<1s>" };

# Man City
set Man_City := { read "data/Man City_players.dat" as "<1s>" };

# Man Utd
set Man_Utd := { read "data/Man Utd_players.dat" as "<1s>" };

# Newcastle
set Newcastle := { read "data/Newcastle_players.dat" as "<1s>" };

# Norwich
set Norwich := { read "data/Norwich_players.dat" as "<1s>" };

# Southampton
set Southampton := { read "data/Southampton_players.dat" as "<1s>" };

# Spurs
set Spurs := { read "data/Spurs_players.dat" as "<1s>" };

# Watford
set Watford := { read "data/Watford_players.dat" as "<1s>" };

# West Ham
set West_Ham := { read "data/West Ham_players.dat" as "<1s>" };

# Wolves
set Wolves := { read "data/Wolves_players.dat" as "<1s>" };

# Gameweeks
set Gameweeks := { 1 .. gweeks };

# --------------------------->>> Data <<<---------------------------
# Predicted scores
param Score[Players*Gameweeks] := read "data/players_season_predicted_scores.dat" as "n+";

# Players costs
param Costs[Players] := read "data/players_costs.dat" as "<1s> 2n";

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
subto Arsenal_players:
  sum <p> in Arsenal: y[p] <= 3;

subto Aston_Villa_players:
  sum <p> in Aston_Villa: y[p] <= 3;

subto Brentford_players:
  sum <p> in Brentford: y[p] <= 3;

subto Brighton_players:
  sum <p> in Brighton: y[p] <= 3;

subto Burnley_players:
  sum <p> in Burnley: y[p] <= 3;

subto Chelsea_players:
  sum <p> in Chelsea: y[p] <= 3;

subto Crystal_Palace_Players:
  sum <p> in Crystal_Palace: y[p] <= 3;

subto Everton_players:
  sum <p> in Everton: y[p] <= 3;

subto Leeds_players:
  sum <p> in Leeds: y[p] <= 3;

subto Leicester_players:
  sum <p> in Leicester: y[p] <= 3;

subto Liverpool_players:
  sum <p> in Liverpool: y[p] <= 3;

subto Man_City_Players:
  sum <p> in Man_City: y[p] <= 3;

subto Man_Utd_Players:
  sum <p> in Man_Utd: y[p] <= 3;

subto Newcastle_players:
  sum <p> in Newcastle: y[p] <= 3;

subto Norwich_players:
  sum <p> in Norwich: y[p] <= 3;

subto Southampton_players:
  sum <p> in Southampton: y[p] <= 3;

subto Spurs_players:
  sum <p> in Spurs: y[p] <= 3;

subto Watford_players:
  sum <p> in Watford: y[p] <= 3;

subto West_Ham_players:
  sum <p> in West_Ham: y[p] <= 3;

subto Wolves_players:
  sum <p> in Wolves: y[p] <= 3;
