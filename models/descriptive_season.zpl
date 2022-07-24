
# This is a base model: Do not take into account:
#   - Players cost changes between gameweeks.
#   - Players cost sell-buy gap
#   - Accumulative transfers

# --------------------------->>> Params <<<---------------------------
param gweeks := 38;
param penalty_by_transfer:= 4;

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

# Transfers Gameweeks
set Transfers_Gameweeks := { 2 .. gweeks };

# --------------------------->>> Data <<<---------------------------
# Predicted scores
param Score[Players*Gameweeks] := read "data/players_season_predicted_scores.dat" as "n+";

# Players costs
param Costs[Players] := read "data/players_costs.dat" as "<1s> 2n";

# Players teams
param Team[Players] := read "data/players_teams.dat" as "<1s> 2s";

# --------------------------->>> Variables <<<---------------------------
# Is the player on the team on gameweek j?
var player_on_team[Players*Gameweeks] binary;

# Is the player in the line-up on gameweek j?
var player_on_lineup[Players*Gameweeks] binary;

# Is the player selected as captain on gameweek j?
var player_is_captain[Players*Gameweeks] binary;

# Is the player involved on a transfer on gameweek j?
var player_is_transfered[Players*Transfers_Gameweeks] integer;

# Is the player sold on gameweek j?
var player_is_sold[Players*Gameweeks] binary;

# Number of extra transfers made on gameweek j?
var extra_transfers_made[Gameweeks] integer;

# --------------------------->>> Objective Function <<<---------------------------
maximize fobj: sum <p,g> in Players*Gameweeks: (Score[p,g] * (player_on_lineup[p,g] + player_is_captain[p,g]) - penalty_by_transfer * player_is_sold[p,g]);

# --------------------------->>> Subject To: <<<---------------------------
# Total number of players selected
subto total_players: forall <g> in Gameweeks:
  sum <p> in Players: player_on_team[p,g] == 15;

# Players by position on team
subto gkp_on_team: forall <g> in Gameweeks:
  sum <p> in Goalkeepers: player_on_team[p,g] == 2;

subto def_on_team: forall <g> in Gameweeks:
  sum <p> in Defenders: player_on_team[p,g] == 5;

subto med_on_team: forall <g> in Gameweeks:
  sum <p> in Midfielders: player_on_team[p,g] == 5;

subto fwd_on_team: forall <g> in Gameweeks:
  sum <p> in Forwards: player_on_team[p,g] == 3;


# Player on line up must be on team
subto line_up_on_team: forall <p,g> in Players*Gameweeks:
  player_on_lineup[p,g] <= player_on_team[p,g];

# Player line up must be of 11 players:
subto line_up_by_gw: forall <g> in Gameweeks:
  sum <p> in Players: player_on_lineup[p,g] == 11;

# Players by position on line up
subto gkp_on_line_up: forall <g> in Gameweeks:
  sum <p> in Goalkeepers: player_on_lineup[p,g] == 1;

subto def_on_line_up: forall <g> in Gameweeks:
  sum <p> in Defenders: player_on_lineup[p,g] >= 3;

subto mid_on_line_up: forall <g> in Gameweeks:
  sum <p> in Midfielders: player_on_lineup[p,g] >= 2;

subto fwd_on_line_up: forall <g> in Gameweeks:
  sum <p> in Forwards: player_on_lineup[p,g] >= 1;


# One captain by gameweek
subto captain_on_line_up: forall <g> in Gameweeks:
  sum <p> in Players: player_is_captain[p,g] == 1;

# Captain must be on line up
subto captain_by_gw: forall <p,g> in Players*Gameweeks:
  player_is_captain[p,g] <= player_on_lineup[p,g];


# Team capacity
subto team_constrain: forall <t,g> in Teams*Gameweeks:
  sum <p> in Players with Team[p] == t: player_on_team[p,g] <= 3;


# Budget
subto budget: forall <g> in Gameweeks:
  sum <p> in Players: Costs[p] * player_on_team[p,g] <= 100;


# Transfers
subto player_transfered_on_gameweek: forall <p,g> in Players*Transfers_Gameweeks:
  player_is_transfered[p,g] == player_on_team[p,g-1] - player_on_team[p,g]

subto players_transfered_balance: forall <g> in Transfers_Gameweeks:
  sum <p> in Players: player_is_transfered[p,g] == 0

subto players_is_sold: forall <g> in Transfers_Gameweeks:
  player_is_transfered[p,g] <= player_is_sold[p,g]


# Transfer Counters
#subto players_transfered_counter: forall <g> in Transfers_Gameweeks:
#  sum <p> in Players: player_is_sold[p,g] == extra_transfers_made[g]
