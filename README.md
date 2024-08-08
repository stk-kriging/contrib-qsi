# contrib-qsi

This repository proposes an implementation of the QSI-SUR criterion described in the article:

Romain Ait Abdelmalek-Lomenech (†), Julien Bect  (†),
Vincent Chabridon (§) and Emmanuel Vazquez  (†)  
__Bayesian sequential design of computer experiments for quantile set
inversion__ ([arXiv:2211.01008](https://arxiv.org/abs/2211.01008))

(†) Université Paris-Saclay, CNRS, CentraleSupélec,
[Laboratoire des signaux et systèmes](https://l2s.centralesupelec.fr/),
Gif-sur-Yvette, France.  
(§) EDF R&D, Chatou, France.

It also includes the implementation of some other Bayesian set inversion methods.

For the experiments of the article, please refer to [`https://github.com/stk-kriging/qsi-paper-experiments`](https://github.com/stk-kriging/qsi-paper-experiments).


## Requirements

Utilization of the functions of this repository requiers Matlab (R2014a or newer) and the toolbox `STK (v2.8.1)`[https://github.com/stk-kriging/stk/tree/2.8.1]. 
The corresponding version of STK is automatically download when launching `startup.m`.


## How to use this repository

In what follows, the following convention are used:
- `it` designates a unique (integer) numerical identifier.
- `data_dir` is the path to a data storage folder, containing the subdirectory `doe_init`, `grid`, `results/design`, `results/param`, `results/deviations`, `results/time` and `results\graphs`.

The `data_dir` directory is used to save, temporarily or definitely, all the data generated and used for the construction of sequential designs using the provided strategies. By default,
`data_dir = path_to_this_repo/data`.

Some examples scripts can be found in the folder [`examples`](examples), and in the [`repository`](https://github.com/stk-kriging/qsi-paper-experiments) 
dedicated to the experiments displayed in the article. 


### Describing a QSI problem

Each test `function` (and associated QSI problem) is described by several files:
- `function.m` or `function.py`, the associated function either coded
  in matlab or python.
- `function_s_trnsf.m`, the inverse mapping associated to the
  probability distribution on the uncertain inputs.
- `function_struct.m`, describing the problem (threshold, critical
  region, input spaces...)
- `function_config.m`, a configuration file for the different
  matlab-implemented strategies (number of steps, size of the
  integration grid, number of candidates points...).

Several test functions, used in the original article, are already provided in the folder [`test_functions`](test_functions) . 
For a full description of the different parameters, please refer to `test_functions/example_struct.m` and `test_functions/example_config.m`.


### Constructing a Bayesian sequential design

Given a well described problem, the first step is to generate one (or several) initial designs by using `generate_doe_init(@funct_struct, @funct_config, it, file_dir)`. These initial designs are stored in `data_dir/doe_init`.

A sequential design can then be generated, using a chosen strategy, by executing `strategy(@funct_struct, @funct_config, it, data_dir)`.
The available strategies are QSI-SUR (`QSI_SUR.m`), Joint-SUR (`joint_SUR.m`), Ranjan (`Ranjan.m`), max. misclassification (`misclassification.m`) and random sampling (`random.m`).

The generated designs, estimated covariance type and parameters are stored in `data_dir/results/design` and `data_dir/results/param`.


### Using the sequential designs

The generated designs can be used, independantly, for different prediction and uncertainty quantification task in combination with the STK toolbox.

It is possible to extract, step by step, the proportion of misclassified points regarding the provided QSI problem, by executing
`extract_deviation(@funct_struct, @funct_config, method, it, data_dir)`, where `method` is the identifier of the considered strategy (see `misc/extract_deviation.m` for more details).
The results are stored in `data_dir/results/deviations`.


### About computational cost.

SUR methods tend to be computationaly costly. In particular, the QSI-SUR criterion relies heavily on conditial Gaussian sample paths. It is possible to adapt to a given computational budget by several means, in particular:

- By using parallel computing (see [`parpool`](https://fr.mathworks.com/help/parallel-computing/parpool.html)).
- By tuning the methods parameters provided in the `funct_config.m` file.
- By, in the case of repeated experiments, using only a small number of runs of the differents strategies.


## Acknowledgements

This work has been funded by the French National Research
Agency (ANR), in the context of the project SAMOURAI (ANR-20-CE46-0013).


## Copyright & license

Copyright 2024 CentraleSupélec

These computer programs are free software: you can redistribute them
and/or modify them under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the
license, or (at your option) any later version.

They are distributed in the hope that they will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.

You should have received a copy of the license along with the software
(see [COPYING.md](./COPYING.md)).  If not, see <http://www.gnu.org/licenses/>.
