# contrib-qsi
This repository proposes an implementation of the QSI-SUR criterion described in `https://arxiv.org/abs/2211.01008`, and of some other methods for Bayesian set inversion.
For the experiments of the article, please refer to `https://github.com/stk-kriging/qsi-paper-experiments`.

## Requirements

Utilization of the functions of this repository requiers Matlab (R2014a or newer) and the toolbox STK (v2.8.1). The corresponding version of STK can be found at
`https://github.com/stk-kriging/stk/tree/2.8.1`.

## Describing a QSI problem

Each test `function` (and associated QSI problem) MUST be composed and described by several files:
- `function.m`, the associated function.
- `function_s_trnsf.m`, the inverse mapping associated to the probability distribution on the uncertain inputs.
- `function_struct.m`, describing the problem (threshold, critical region, input spaces...)
- `function_config.m`, a configuration file for the different matlab-implemented strategies (number of steps, size of the integration grid, number of candidates points...).

Several test functions, used in the original article, are already provided. All the related files are located in `test_functions`, except for the base function `volcano.m` 
(`https://github.com/stk-kriging/qsi-paper-experiments/testcases/volcano`). For a full description of the different parameters, it is possible to refer to `test_functions/example_struct.m` 
and `test_functions/example_config.m`.

## Utilization

Given a well described problem, the first step is to generate one (or several) initial designs by using `generate_doe_init(@funct_struct, @funct_config, it)`, where `it` is a unique numerical identifier.

A sequential design can then be generated, using a chosen strategy, by executing `strategy(@funct_struct, @funct_config, it, filePath)`, where `filePath` is the path to a data storage folder. By default `filePath = data/`.
The available strategies are QSI-SUR (`QSI_SUR.m`), Joint-SUR (`joint_SUR.m`), Ranjan (`Ranjan.m`), max. misclassification (`misclassification.m`) and random sampling (`random.m`).

The generated designs, estimated covariance type and parameters are stored in `filePath/results/designs` and `filepath/results/param`

## Acknowledgements

This repository is part of a work funded by the French National Research Agency (ANR), in the context of the project SAMOURAI (ANR-20-CE46-0013).
