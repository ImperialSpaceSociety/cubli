%% PLANT model and data

% this script describes all the system data. They are stored as attributes
% of a global struct (cubli). This struct will have global scope in order
% to be accessed by all the methods and scripts. 
global cubli

% Cubli physical parameters
% Frame side length [m]
cubli.params.Lt = 0.085;
% Center of Mass (distance from pin point) [m]
cubli.params.COM = cubli.params.Lt*sqrt(2);
% Frame Mass [kg]
cubli.params.M = 0.419;
% gravity acceleration [m/s^2]
cubli.params.g = 9.81;
% Reaction wheel friction coefficient
cubli.params.Fw = 0.05e-3;
% Frame revolute joint friction coefficient
cubli.params.Fc = 1.02e-3;
% Cubli frame inertia (wr2 COM) [kg*m^2]
cubli.params.If = 3.34e-3;
% Reaction wheel inertia (wr2 COM) [kg*m^2]
cubli.params.Iw = 0.57e-3;
% Electric motor constant (from current to torque)
cubli.params.Km = 1;

% hybrid model: the Cubli is described as a continous time mode during the
% free fall and balancing action. Once it hits the ground a discontinuity
% in the model is introduced, namely the instantaneous velocity is zero and
% the acceleration changes in sign. Thi kind of model is called hybrid as
% it is described by both a continuous and discrete state space model. 

% these values define when the Cubli hits the ground and when to saturate
% the velocities to zero
cubli.hit_angle = pi/2;
cubli.zero_thresh_angle = 1e-4;

% simulation data
% initial time instant
cubli.simulation.Tstart = 0;
% final time instant
cubli.simulation.Tend = 10;
% simulation integration step
cubli.simulation.Ts = 1e-2;
% total time vector
cubli.simulation.time = cubli.simulation.Tstart:cubli.simulation.Ts:cubli.simulation.Tend;
% number of integration step
cubli.simulation.Niter = length(cubli.simulation.time);

% cubli model version (see the related file)
cubli.simulation.model = @cubli_model_v5;

% number of states (position and velocity for both frame and wheel)
cubli.StateDim = 4;

% Cubli initial condition
cubli.init_condition = [-pi/4; 0; 0; 0];

% input flag (1:enabled, 0:disabled)
cubli.input_flag = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL SIGNALS: select one for testing

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input actual signal
cubli.params.U = cubli.params.Tm;