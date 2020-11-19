%% Init section 

global cubli

clc
addpath(genpath(pwd));
cubli_init;

% state storage
cubli.stateStory = zeros(cubli.StateDim,cubli.simulation.Niter);
cubli.stateStory(:,1) = cubli.init_condition;

% model simulation
disp('Model simulation')


% model integration
for k=2:cubli.simulation.Niter 
    % update iteration
    cubli.iteration = k;
    
    % system control input
    set_input(k);
    cubli.stateStory(:,k) = PlantJumpMap_general_notime(cubli.stateStory(:,k-1),cubli.simulation.model,1);            
end       

% analysis
cubli.coordinates = zeros(cubli.simulation.Niter,2);
cubli.coordinates(:,1) = cubli.params.COM*sin(cubli.stateStory(1,:));
cubli.coordinates(:,2) = cubli.params.COM*cos(cubli.stateStory(1,:));