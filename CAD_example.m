%%%%%%%%%%%%%%%%%%%%%%%%%% TUTORIAL ON CELL ASSEMBLY DETECTION %%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear; clc;
load('testData/test_data.mat');  % Contains spM

addpath('CADfunc/');
addpath('CADfunc/CreateTestData');
addpath('CADfunc/ExtraPlotFn');
%%
nneu = size(spM,1);
BinSizes=[0.015 0.025 0.04 0.06 0.085 0.15 0.25 0.4 0.6 0.85 1.5];

MaxLags=10*ones(size(BinSizes));
% Restrict MaxLags so that total assembly length is less than ~=2 s
%MaxLags = min(MaxLags,ceil(2./BinSizes));


% This is a threshold on E[AB]. Below this threshold, pairs will NOT be
%   tested for correlations.
Exp_thres = 1;


%% %%%%%%%%%%%%%%%%%%%% ASSEMBLY DETECTION %%%%%%%%%%%%%%%%%%%%%%%

% 
% Use "plotOnly" if you have already run the algorithm, and just 
%  want to experiment with the visualizations/pruning options.
%
plotOnly = 1;
if (plotOnly)
    load('test_CAD_example.mat','assembly');
else
    [assembly]=Main_assemblies_detection(spM,MaxLags,BinSizes, Exp_thres,...
        0,0.05,100);

    %% If you want to save your results for future reference
    %save('test_CAD_example.mat','assembly');
end
%%


%% %%%%%%%%%%%%%%%%%%%%%%%% VISUALIZATION %%%%%%%%%%%%%%%%%%%%%%%%

% ASSEMBLY REORDERING
figure(1)
[As_across_bins,As_across_bins_index]=assemblies_across_bins(assembly,BinSizes);
display='raw';
% display='clustered';
% VISUALIZATION
[Amatrix,Binvector,Unit_order,As_order]=...
  assembly_assignment_matrix(As_across_bins, nneu, BinSizes, display,1);

%% %%%%%%%%%%%%%%%%%%%%%%%% PRUNING %%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
% PRUNING: criteria = 'biggest';
criteria = 'biggest';
[As_across_bins_pr,As_across_bins_index_pr]=...
  pruning_across_bins(As_across_bins,As_across_bins_index,nneu,criteria);

display='raw';
[Amatrix,Binvector,Unit_order,As_order]=...
  assembly_assignment_matrix(As_across_bins_pr, nneu, BinSizes, display,1);

%% %%%%%%%%%%%%%%%%%%%%%%%% ASSEMBLY ACTIVATION %%%%%%%%%%%%%%%%%%%%%%%%
figure(3)

lagChoice = 'beginning';
% lagChoice='duration';

act_count = 'full';
[assembly_activity]=Assembly_activity_function(As_across_bins_pr,assembly,...
    spM,BinSizes,lagChoice,act_count);

%% Plot assembly activity over time
for i=1:min(length(assembly_activity),5)
    subplot(5,1,i)
    plot(assembly_activity{i}(:,1),assembly_activity{i}(:,2));
    hold on
end



%% %%%% Another style of raster plot: view each assembly individually %%

figure(4)
nr = numel(As_across_bins_pr);
for jj = 1:numel(As_across_bins_pr)
    subplot(nr,1,jj);
    %if numel(As_across_bins_pr{jj}.elements)==5
     view_assembly_activity_fn(As_across_bins_pr(jj),spM);
   % end
end



%% %%%%%%%%%%%%%%% RASTER PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    First use RD17 function to extract assembly-linked spikes
[AAspM,AAasspikes]=assembly_rasterplot(As_across_bins_pr,assembly_activity,spM,0);
    
%% Set up parameters for raster plots
rasterpm.UseUnitOrder = 1;
rasterpm.Unit_order = Unit_order;
rasterpm.PlotParticipatingUnitsOnly = 0;
rasterpm.color_assign_type = 1;
rasterpm.PauseBetweenAssemb = 0;

% This will rotate through colors: each assembly in a different color
hr1  = raster_all_assemblies_fn( spM,AAasspikes,As_across_bins_pr,...
    As_order,BinSizes,rasterpm);
set(gca,'FontSize',14); title('Without adjustment');
axis tight; ylim([0.5,nneu+0.5]);

%% %%%%%%%%%%%%%%% RASTER PLOT: ADJUSTED ACTIVITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subtract off "expected" assembly activity due to 
% background firing rate
[assembly_activity_adj]=Adjust_AsAct(assembly_activity,As_across_bins_pr,assembly,...
    spM,BinSizes);

% Find spikes associated w/ the assembly
[AAspMAdj,AAasspikesAdj]=assembly_rasterplot(As_across_bins_pr,...
    assembly_activity_adj,spM,0);

hr2  = raster_all_assemblies_fn( spM,AAasspikesAdj,As_across_bins_pr,...
    As_order,BinSizes,rasterpm);
set(gca,'FontSize',14); title('With adjustment');
axis tight; ylim([0.5,nneu+0.5]);
