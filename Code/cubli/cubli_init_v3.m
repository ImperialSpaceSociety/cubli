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
cubli.params.Fw = 0.05e-2;
% Frame revolute joint friction coefficient
cubli.params.Fc = 1.02e-3;
% Cubli frame inertia (wr2 COM) [kg*m^2]
cubli.params.If = 3.34e-3;
% Reaction wheel inertia (wr2 COM) [kg*m^2]
cubli.params.Iw = 0.57e-2;
% Electric motor constant (from current to torque)
cubli.params.Km = 1e0;

% hybrid model: the Cubli is described as a continous time mode during the
% free fall and balancing action. Once it hits the ground a discontinuity
% in the model is introduced, namely the instantaneous velocity is zero and
% the acceleration changes in sign. Thi kind of model is called hybrid as
% it is described by both a continuous and discrete state space model. 

% these values define when the Cubli hits the ground and when to saturate
% the velocities to zero
cubli.hit_angle = pi/2;
cubli.zero_thresh_vel = 1e-2;

% flags init
cubli.stop = 0;
cubli.charging = 0;

% simulation data
% initial time instant
cubli.simulation.Tstart = 0;
% final time instant
cubli.simulation.Tend = 20;
% sampling time
cubli.simulation.Ts = 5e-3;
% time array
cubli.simulation.time = cubli.simulation.Tstart;

% cubli model version (see the related file)
cubli.simulation.model = @cubli_model;

% number of states (position and velocity for both frame and wheel)
cubli.StateDim = 4;

% Cubli initial condition
init_angle_deg = -15; %[deg]
init_angle_rad = deg2rad(init_angle_deg); %[deg]
cubli.init_condition = [init_angle_rad; 0; 0; 0];
cubli.stateStory = (cubli.init_condition.*ones(cubli.StateDim,2))';

% input flag (1:enabled, 0:disabled)
cubli.input_flag = 1;
cubli.target_angle = 0;
cubli.brake_torque = 1;
cubli.input_story = 0;

% error
cubli.e_story = 0;
cubli.edot_story = 0;
cubli.eint_story = 0;
cubli.cl = 1;
cubli.dl = 3;
cubli.e_buf = zeros(1,cubli.dl);