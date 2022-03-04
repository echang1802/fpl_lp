
from scipy.optimize import linprog

class optimizer:

    def __init__(self, fpl):

        # Inicialize variables
        self._total_players = fpl.total_players()
        self._scores = [None] * self._total_players # Objective function
        self._costs = [None] * self._total_players
        self._goalkeepers = []
        self._defenders = []
        self._midfielders = []
        self._forwards = []
        self._players_name = [None] * self._total_players

        # Get values
        self._get_info(fpl)

    def _get_info(self, fpl):
        add_positions = {
            1 : lambda x: self._goalkeepers.append(x),
            2 : lambda x: self._defenders.append(x),
            3 : lambda x: self._midfielders.append(x),
            4 : lambda x: self._forwards.append(x)
        }
        for player in fpl.players():
            self._scores[player["id"] - 1] = -player["event_points"]
            self._costs[player["id"] - 1] = player["now_cost"] / 10
            add_positions[player["element_type"]](player["id"] - 1)
            self._players_name[player["id"] - 1] = f"{player['first_name']} {player['second_name']}"


    def declare_constrains(self, budget = 100):
        self._lhs_ub = []
        self._rhs_ub = []
        self._lhs_eq = []
        self._rhs_eq = []
        self._declare_total_players_constain()
        self._declare_goalkeeper_constrain()
        self._declare_defenders_constrain()
        self._declare_midfielders_constrain()
        self._declare_forwards_constrain()
        self._declare_budget_constrain(budget)
        self._declare_bound_constrain()


    def _declare_total_players_constain(self):
        self._lhs_eq.append([1] * self._total_players)
        self._rhs_eq.append([11])


    def _declare_goalkeeper_constrain(self):
        self._lhs_eq.append([int(x in self._goalkeepers) for x in range(self._total_players)])
        self._rhs_eq.append([1])


    def _declare_defenders_constrain(self):
        self._lhs_ub.append([-int(x in self._defenders) for x in range(self._total_players)])
        self._rhs_ub.append([-3])


    def _declare_midfielders_constrain(self):
        self._lhs_ub.append([-int(x in self._midfielders) for x in range(self._total_players)])
        self._rhs_ub.append([-2])


    def _declare_forwards_constrain(self):
        self._lhs_ub.append([-int(x in self._forwards) for x in range(self._total_players)])
        self._rhs_ub.append([-1])


    def _declare_budget_constrain(self, budget):
        self._lhs_ub.append(self._costs)
        self._rhs_ub.append([budget])


    def _declare_bound_constrain(self):
        self._bounds = [(0,1)] * self._total_players


    def run(self):
        result = linprog(c = self._scores,
            A_ub = self._lhs_ub, b_ub = self._rhs_ub,
            A_eq = self._lhs_eq, b_eq = self._rhs_eq,
            bounds = self._bounds,
            method = "revised simplex")

        print(f"Optimal: {-result.fun}")
        for x in range(self._total_players):
            if result.x[x] == 0:
                continue
            print(self._players_name[x])
