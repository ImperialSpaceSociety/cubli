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

% integration options
options = odeset('Events',@ODEstop);

%% model simulation
disp('Model simulation')

% model integration
k = 2;
event = 0;

while (k<=cubli.simulation.Niter) && (~event)
    
    % integration
    clc
    disp(['integration step: ',int2str(k),'/',int2str(cubli.simulation.Niter)]);
    
    % current time index
    cubli.iteration = k;
    
    % system control input
    set_input_v2;
    
    % initial condition for next step
    xpast = cubli.stateStory(:,k-1);
    
    % time interval for next step
    tm = [cubli.simulation.time(k-1),cubli.simulation.time(k)];
    
    % Integrate ODE for 1 sec each loop
    z = ode45(@(t,x)cubli_model(t,x),tm,xpast,options);
    
    % store state
    cubli.stateStory(:,k) = z.y(:,end);
    
    % event
    event = ~isempty(z.xe);
    
    k = cubli.iteration+1;
end   

% fit the rest of the stateStory
cubli.stateStory(:,cubli.iteration+1:end) = cubli.stateStory(:,cubli.iteration).*ones(cubli.StateDim,cubli.simulation.Niter-cubli.iteration);

% compute the coordinates of the center of mass from state variable
cubli.coordinates = zeros(cubli.simulation.Niter,2);
cubli.coordinates(:,1) = cubli.params.COM*sin(cubli.stateStory(1,:));
cubli.coordinates(:,2) = cubli.params.COM*cos(cubli.stateStory(1,:));