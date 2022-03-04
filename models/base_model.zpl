
# This is a base model: Do not take into account:
# - Max 3 player for each club
# - Max number of player on any position (Except goalkeeper)
# - Captain selection
# - Transfers (Just select the gameweek dreamteam)

# --------------------------->>> Sets <<<---------------------------
# Players
set Players := { read "data/players_predicted_scores.dat" as "<1s>" };

# Goalkeepers
set Goalkeepers := { read "data/goalkeepers.dat" as "<1s>" };

# Defenders
set Defenders := { read "data/defenders.dat" as "<1s>" };

# Midfielders
set Midfielders := { read "data/midfielders.dat" as "<1s>" };

# Forwards
set Forwards := { read "data/forwards.dat" as "<1s>" };

# --------------------------->>> Data <<<---------------------------
# Predicted scores
param Score[Players] := read "data/players_predicted_scores.dat" as "<1s> 2n";

# Players costs
param Costs[Players] := read "data/players_costs.dat" as "<1s> 2n";

# --------------------------->>> Variables <<<---------------------------
# Is the player selected?
var x[Players] binary;

# --------------------------->>> Objective Function <<<---------------------------
maximize fobj: sum <p> in Players: Score[p] * x[p];

# --------------------------->>> Subject To: <<<---------------------------
# Total number of players selected
subto total_players:
  sum <p> in Players: x[p] == 11;

# Goalkeepers selected
subto gkp_constraint:
  sum <p> in Goalkeepers: x[p] == 1;

# Defenders selected
subto def_constraint:
  sum <p> in Defenders: x[p] >= 3;

# Midfielders selected
subto mid_constraint:
  sum <p> in Midfielders: x[p] >= 2;

# Forwards selected
subto fwd_constraint:
  sum <p> in Forwards: x[p] >= 1;

# Budget
subto budget:
  sum <p> in Players: Costs[p] * x[p] <= 100;
