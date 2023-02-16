

# Value-based Uncertainty Estimation (VUE) model

To fit the model, you should activate and precompile the `VUE` package in julia

## Runfiles

### data generation file

`gen_data_for_fitting.jl` preparing data for VUE 

`gen_simu.py` generate simulated results

`gen_best_param.jl` select the best parameters from the fitted results

### fitting files

`autorun_mean.sh` : VUE model under CUE condition

`autorun_mean_stdR.sh` : fix VUE model parameters except parameter R under standard condition. It should be run after `autorun_mean.sh`

`autorun_mean_tt.sh` : deadline model under CUE condition

`autorun_mean_2D3B.sh` : race model under CUE condition

### covertion files

covnert julia generated results to python readable files for plotting

`jl-connect.py` : transfer julia result to python format with applicable data for plotting

`jl-connect-others.py` : transfer julia result to python format for deadline and race model. Run after `gen_others_fig_data.jl`

`replication-on-kiani09.ipynb (julia)` : the simulation to replicate Kiani & Shadlen (2009)

`gen_others_fig_data.jl` : generate applicable data for plotting

If you have any problem running these files, please contact flumer@qq.com