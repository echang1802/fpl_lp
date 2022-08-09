# fpl_lp

Linear programing tests over the team selection on the Fantasy Premier League


## ZPL - SCIP Model

To run the model go to model folder on a command window and type:  (on Windows)

```
scip -f base_model.zpl -l result.log
```

## SciPy Model

Is the same model but this implementation is not attached to some .dat files, it use the fpl API to get the scores points, to run it go to base project directory on an anaconda promp and type

```
python main.py
```
