%% Init section 

% global struct. Each attribute describes a parameter that will be used in
% the model and simulation procedures. 
global cubli

% clear the workspace and command line
clear all
clc

% add current folder to the library path 
addpath(genpath(pwd));

% init the cubli structure (set inertias, model version, control...)
cubli_init_v2;

% init state storage variables
cubli.stateStory = zeros(cubli.StateDim,cubli.simulation.Niter);
cubli.stateStory(:,1) = cubli.init_condition;


%% model simulation
disp('Model simulation')

% model integration
k = 2;
while k<=cubli.simulation.Niter
    
    % current time index
    cubli.iteration = k;
    
    % system control input
    set_input_v2;
    
    % propagate 
    cubli.stateStory(:,cubli.iteration) = PlantJumpMap_hybrid(cubli.stateStory(:,cubli.iteration-1),cubli.simulation.model,1);
    if cubli.hit == 1
        cubli.stateStory(:,cubli.iteration-1) = cubli.stateStory(:,cubli.iteration);
        cubli.hit = 0;
    end
    
    k = cubli.iteration+1;
end       

% compute the coordinates of the center of mass from state variable
cubli.coordinates = zeros(cubli.simulation.Niter,2);
cubli.coordinates(:,1) = cubli.params.COM*sin(cubli.stateStory(1,:));
cubli.coordinates(:,2) = cubli.params.COM*cos(cubli.stateStory(1,:));