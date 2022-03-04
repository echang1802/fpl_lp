
from api_fpl.requests import api
from optimizer.opt import optimizer

if __name__ == "__main__":

    fpl = api()

    opt = optimizer(fpl)

    opt.declare_constrains(100)

    opt.run()
