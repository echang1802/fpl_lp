
import yaml
import requests

class api:

    def __init__(self):

        self._read_conf()
        self._get_base_info()


    def _read_conf(self):
        with open('confs.yml') as f:
            confs = yaml.safe_load(f)["fpl"]
            self._base_url = confs["base_url"]
            self._endpoints = confs["endpoints"]


    def _request(self, endpoint, param = ""):
        url = f"{self._base_url}{self._endpoints[endpoint]}{param}/"
        result = requests.get(url)
        return result.json()


    def _get_base_info(self):
        results = self._request("base")
        self._parse_teams(results["teams"])
        self._parse_players(results["elements"])


    def _parse_teams(self, results):
        self._teams = results # To do: Keep only values used


    def _parse_players(self, results):
        self._players = results # To do: Keep only values used


    def total_players(self):
        return len(self._players)


    def players(self):
        return self._players

    def teams(self):
        return self._teams
