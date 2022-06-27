
# This is a base model: Do not take into account:
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
subto def_constraint_lb:
  sum <p> in Defenders: x[p] >= 3;

subto def_constraint_ub:
  sum <p> in Defenders: x[p] <= 5;

# Midfielders selected
subto mid_constraint_lb:
  sum <p> in Midfielders: x[p] >= 2;

subto mid_constraint_ub:
  sum <p> in Midfielders: x[p] <= 5;

# Forwards selected
subto fwd_constraint_lb:
  sum <p> in Forwards: x[p] >= 1;

subto fwd_constraint_ub:
  sum <p> in Forwards: x[p] <= 3;

# Budget
subto budget:
  sum <p> in Players: Costs[p] * x[p] <= 100;

# Team capacity
subto Arsenal_players:
  sum <p> in Arsenal: x[p] <= 3;

subto Aston_Villa_players:
  sum <p> in Aston_Villa: x[p] <= 3;

subto Brentford_players:
  sum <p> in Brentford: x[p] <= 3;

subto Brighton_players:
  sum <p> in Brighton: x[p] <= 3;

subto Burnley_players:
  sum <p> in Burnley: x[p] <= 3;

subto Chelsea_players:
  sum <p> in Chelsea: x[p] <= 3;

subto Crystal_Palace_Players:
  sum <p> in Crystal_Palace: x[p] <= 3;

subto Everton_players:
  sum <p> in Everton: x[p] <= 3;

subto Leeds_players:
  sum <p> in Leeds: x[p] <= 3;

subto Leicester_players:
  sum <p> in Leicester: x[p] <= 3;

subto Liverpool_players:
  sum <p> in Liverpool: x[p] <= 3;

subto Man_City_Players:
  sum <p> in Man_City: x[p] <= 3;

subto Man_Utd_Players:
  sum <p> in Man_Utd: x[p] <= 3;

subto Newcastle_players:
  sum <p> in Newcastle: x[p] <= 3;

subto Norwich_players:
  sum <p> in Norwich: x[p] <= 3;

subto Southampton_players:
  sum <p> in Southampton: x[p] <= 3;

subto Spurs_players:
  sum <p> in Spurs: x[p] <= 3;

subto Watford_players:
  sum <p> in Watford: x[p] <= 3;

subto West_Ham_players:
  sum <p> in West_Ham: x[p] <= 3;

subto Wolves_players:
  sum <p> in Wolves: x[p] <= 3;
