%% Init section 

% global struct. Each attribute describes a parameter that will be used in
% the model and simulation procedures. 
global cubli

% clear the command line
clc

% add current folder to the library path 
addpath(genpath(pwd));

% init the cubli structure (set inertias, model version, control...)
cubli_init;

% init state storage variables
cubli.stateStory = zeros(cubli.StateDim,cubli.simulation.Niter);
cubli.stateStory(:,1) = cubli.init_condition;


%% model simulation
disp('Model simulation')

% model integration
for k=2:cubli.simulation.Niter 
    
    % update iteration
    cubli.iteration = k;
    
    % system control input
    set_input(k);
    
    % propagate 
    cubli.stateStory(:,k) = PlantJumpMap_general_notime(cubli.stateStory(:,k-1),cubli.simulation.model,1);            
end       

% compute the coordinates of the center of mass from state variable
cubli.coordinates = zeros(cubli.simulation.Niter,2);
cubli.coordinates(:,1) = cubli.params.COM*sin(cubli.stateStory(1,:));
cubli.coordinates(:,2) = cubli.params.COM*cos(cubli.stateStory(1,:));