# CAD_toolbox
Detect correlated activity in neural spike trains

Modified from code published by Russo and Durstewitz, 2017.

Main modifications:
  - Extended lower threshold for pairwise correlation test (Truong 2020)  
  - Added Compressed Replay pruning algorithm (beta: Truong 2020)    
  - Added data generation routines for:    
      - different types of cell assemblies        
      - activity of hippocampal place cells with/without theta precession  

References:  
  - E. Russo and D. Durstewitz. Cell assemblies at multiple time scales with arbitrary lag constellations. eLife, 6, 2017.   
  - Phan Minh Duc Truong. Cell assembly detection in low firing-rate spike train data. PhD thesis, Southern Methodist University, 2020.  
  
CONTENTS: 
| File name | Description |   
| --------- | -------- |   
| CAD_example.m | Simple tutorial example |   
| Compress_pruning_example.m | Example for compressed replay detection (beta) |    
| **CADfunc** | (Original RD17 files)|      
|  CADfunc/Main_assemblies_detection.m  | |  
 | CADfunc/FindAssemblies_recursive.m  | |  
 | CADfunc/TestPair.m  | |  
 |CADfunc/Assembly_activity_function.m  | |  
 | CADfunc/assemblies_across_bins.m  | |  
 | CADfunc/assembly_assignment_matrix.m  | |  
 |  CADfunc/assembly_rasterplot.m  | |  
 |  CADfunc/pruning_across_bins.m  | |  
 |  CADfunc/restyle_assembly_lags_time.m  | |  
 | CADfunc/time_rescale.m  | |   
 | **CADfunc** | (Added by Barreiro and/or Truong)  |  
 |  CADfunc/Adjust_AsAct.m  |   Adjusts assembly activity by subtracting off an estimate of baseline activity |  
 | CADfunc/compress_pruning_fn.m  | |  
  |CADfunc/collectsubSpM.m  | |  
  |CADfunc/uniquecell.m  | |  
 | CADfunc/rasterplot_fn.m  | |  
 |  CADfunc/view_assembly_activity_fn.m| |  
|  **CADfunc/CreateTestData** |  |  
| CADfunc/CreateTestData/makeSimulatedAssembData.m            |    Basic driver function for creating data with embedded assemblies  |  
| CADfunc/CreateTestData/genASp_Type#.m  #=1-4          |    Create assemblies of Type # (as defined in RD17) |
| CADfunc/CreateTestData/genASp_LinTrackTheta.m            |    Create assemblies corresponding to a rat running a linear track   |
| CADfunc/CreateTestData/embed_assembly_fn.m            |    Embed assembly spikes into a spike raster  |
| CADfunc/CreateTestData/makeAR.m            |     Makes a slowly varying rate function (for use in creating background spikes |
| CADfunc/CreateTestData/genNHPP.m            |     Generate spike trains for a nonhomogeneous Poisson process |
| CADfunc/CreateTestData/eval_pw_const.m            |     Utility function for genNHPP |
| CADfunc/CreateTestData/embed_alt_data_fn.m            |     Embed original and compressed versions of an assembly (Truong 2020)  |
| CADfunc/CreateTestData/generating_ISI_fn.m            |      |
| CADfunc/CreateTestData/pair_Generator.m            |      |
  | **CADfunc/ExtraPlotFn/** |  |  
  | CADfunc/ExtraPlotFn/plot_assembly_assignment_matrix.m     |    More control over assembly matrix  |   
  | CADfunc/ExtraPlotFn/plot_lines_on_raster.m                |    Plot vertical lines to mark time epochs |    
  | CADfunc/ExtraPlotFn/raster_all_assemblies_fn.m            |    Plot all assemblies in rotating colors  |  
  | CADfunc/ExtraPlotFn/raster_single_assembly_fn.m           |    Plot a single assembly |  



