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
cubli_init_v3;

% integration options
options = odeset('Events',@ODEstop);

%% model simulation
disp('Model simulation')

% model integration
event = 0;

tout = cubli.simulation.Tstart;
tstart = cubli.simulation.Tstart;
xout = cubli.init_condition';
teout = [];
yeout = [];
ieout = [];
while tstart < cubli.simulation.Tend
    
    % integration
    clc
    disp(['integration step: ',num2str(tstart,4),'/',num2str(cubli.simulation.Tend,1)]);
    
    % system control input
    set_input_v2;
    
    % time interval for next step
    tm = [tstart,tstart + cubli.simulation.Ts];
    
    % Integrate ODE for 1 sec each loop
    [t,x,te,ye,ie] = ode23s(@(t,x)cubli_model(t,x),tm,cubli.init_condition,options);
    
    % Accumulate output.  This could be passed out as output arguments.
    nt = length(t);
    tout = [tout; t(2:nt)];
    xout = [xout; x(2:nt,:)];
    teout = [teout; te];          % Events at tstart are never reported.
    yeout = [yeout; ye];
    ieout = [ieout; ie];
    
    if ~isempty(ie)
        % Set the new initial conditions, with attenuation.
        current_vel = abs(x(nt,3));
        if current_vel < cubli.zero_thresh_vel
            rebounce = 0;
            cubli.stop = 1;
            cubli.input_flag = 0;
        else
            rebounce = 0;
            cubli.stop = 1;
            cubli.input_flag = 0;
        end
    else
        rebounce = -1;
    end
    
    cubli.init_condition(1) = x(nt,1);
    cubli.init_condition(2) = x(nt,2);
    cubli.init_condition(3) = -rebounce*x(nt,3);
    cubli.init_condition(4) = x(nt,4);
    
    cubli.stateStory = xout;
   
    tstart = t(nt);
end   


% get storage dimension
cubli.simulation.Niter = length(cubli.stateStory);
cubli.simulation.time = tout;

% compute the coordinates of the center of mass from state variable
cubli.coordinates = zeros(cubli.simulation.Niter,2);
cubli.coordinates(:,1) = cubli.params.COM*sin(cubli.stateStory(:,1));
cubli.coordinates(:,2) = cubli.params.COM*cos(cubli.stateStory(:,1));