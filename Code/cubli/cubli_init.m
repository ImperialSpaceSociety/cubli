%% PLANT model and data
% model simulation
% plant data

global cubli

% phisycal parameters
cubli.params.Lt = 1;
cubli.params.COM = cubli.params.Lt*sqrt(2);
cubli.params.M = 1;
cubli.params.g = 9.81;
cubli.params.Fw = 0.5;
cubli.params.Fc = 0.5;
cubli.params.If = 5;
cubli.params.Iw = 3;
cubli.params.Km = 1;

% hybrid model
cubli.hit_angle = pi/2;
cubli.zero_thresh_angle = 1e-3;
cubli.zero_thresh_vel = 1e-3;

% simulation
cubli.simulation.Tstart = 0;
cubli.simulation.Tend = 10;
cubli.simulation.Ts = 1e-2;
cubli.simulation.time = cubli.simulation.Tstart:cubli.simulation.Ts:cubli.simulation.Tend;
cubli.simulation.Niter = length(cubli.simulation.time);
cubli.simulation.model = @cubli_model_v3;

% init and other conditions/parameters
cubli.StateDim = 4;

% from the top 
cubli.init_condition = [-pi/4; 0; 0; 0];
% from the bottom 
% cubli.init_condition = [0; 0; 0; 0];

% input signal
cubli.input_flag = 0;

% sinusoid
% cubli.params.Tm = cubli.params.Km*sin(20*cubli.simulation.time);

% step
init_step = 100;
cubli.params.Tm = sign(cubli.init_condition(1))*1.2e1*cubli.params.Km*[zeros(1,init_step), ones(1,init_step), zeros(1,cubli.simulation.Niter-2*init_step)];

% pwm
% cubli.params.fc = 0.5;
% cubli.params.a = 0;
% cubli.params.A = -1.2e1;
% cubli.params.Tm = cubli.params.A*cubli.params.Km*pwm_gen(cubli.simulation.time,cubli.params.fc,cubli.params.a);

% input
cubli.params.U = cubli.params.Tm;