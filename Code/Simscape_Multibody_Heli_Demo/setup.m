clear
clc
close all

% [Q1] 
% Use your work from live script and generate the linearised helicopter model linearised around zero, note the changes in system dimension
X0=[0,0,0,0,0,0];
U0=[0,0];
[A1, B1, Ci, Di] = linmod('NonlinearModel', X0, U0);

Ai = [[A1 zeros(6, 2)];[1,0,0,0,0,0,0,0;0,0,1,0,0,0,0,0]];
Bi = [B1; zeros(2)];

%Ai=round(Ai,4)
%Bi=round(Bi,4)

% [Q2]
% LQR-PID Controller design (default)
Q = diag([100 1 10 0 0 2 10 0.1]);
R = diag([0.05 0.05]);
% Calculate the LQR controller gain
K = lqr(Ai, Bi, Q, R);

% Display the calculated gains
disp( 'Calculated LQR controller gain elements (default): ' )
K

% [Q3a/b]
% LQR-PID Controller design (slight improvement)
Q_si = diag([1000 1 10 0 0 2 10 0.1]);
R_si = diag([0.05 0.05]);

% Calculate the LQR controller gain
K_si = lqr(Ai, Bi, Q_si, R_si)
%plot(eig(Ai-Bi*K_si), 'rx');
%grid on
%yline(0, 'b-')
%xline(0, 'b-')

% LQR-PID Controller design (best elevation)
Q_be = diag([1000 0.01 0.01 1 0.01 100 10 0.01]);
R_be = diag([0.01 0.01]);
% Calculate the LQR controller gain
K_be = lqr(Ai, Bi, Q_be, R_be);
    
% LQR-PID Controller design (best travel)
Q_bt = diag([100 1 300 0.001 0 100 0.01 0.01]);
R_bt = diag([0.01 0.01]);
% Calculate the LQR controller gain
K_bt = lqr(Ai, Bi, Q_bt, R_bt);

% LQR-PID Controller design (best overall)
Q_bo = diag([100 20 1000 0.001 1 100 1 0.1]);
R_bo = diag([0.008 0.008]);
% Calculate the LQR controller gain
K_bo = lqr(Ai, Bi, Q_bo, R_bo);

% Display the calculated gains
disp( ' ' )
disp( 'Calculated LQR controller gain elements (slight improvement): ' )
K_si
disp( ' ' )
disp( 'Calculated LQR controller gain elements (best elevation): ' )
K_be
disp( ' ' )
disp( 'Calculated LQR controller gain elements (best travel): ' )
K_bt
disp( ' ' )
disp( 'Calculated LQR controller gain elements (best overall): ' )
K_bo

%% User defined 3DOF helicopter system configuration
% Amplifier Gain used for yaw and pitch axes: set VoltPAQ to 3.
K_AMP = 3;
% Amplifier Maximum Output Voltage (V)
VMAX_AMP = 24;
% Digital-to-Analog Maximum Voltage (V): set to 10 for Q4/Q8 cards
VMAX_DAC = 10;
% Initial elvation angle (rad)
elev_0 = -27.5*pi/180;

%% User defined Filter design
% Specifications of a second-order low-pass filter
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.9;        % filter damping ratio
% Anti-windup: integrator saturation (V)
SAT_INT_ERR_ELEV = 7.5;
SAT_INT_ERR_TRAVEL = 7.5;

%% User defined command settings
% Note: These limits are imposed on both the program and joystick commands.
% Elevation position command limit (deg)
CMD_ELEV_POS_LIMIT_LOWER = elev_0*180/pi;
CMD_ELEV_POS_LIMIT_UPPER = -CMD_ELEV_POS_LIMIT_LOWER;
% Maximum Rate of Desired Position (rad/s)
CMD_RATE_LIMIT = 45.0 * pi / 180;

%% Controller design
K = K_bo;

%% Non-linear model parameters (for closed-loop simulation only):
%Modified on 21/11/2016

%System parameters
% Propeller force-thrust constant found experimentally (N/V)
Kf = 0.1188;
% Mass of the helicopter body (kg)
m_h = 1.308;
% Mass of counter-weight (kg)
m_w = 1.924;
% Mass of front propeller assembly = motor + shield + propeller + body (kg)
m_f = m_h / 2;
% Mass of back propeller assembly = motor + shield + propeller + body (kg)
m_b = m_h / 2;
% Distance between pitch pivot and each motor (m)
Lh = 7.0 * 0.0254;
% Distance between elevation pivot to helicopter body (m)
La = 26.0 * 0.0254;
% Distance between elevation pivot to counter-weight (m)
Lw = 18.5 * 0.0254;
% Gravitational Constant (m/s^2)
g = 9.81;    
par = [Kf;m_h;m_w;m_f;m_b;Lh;La;Lw;g]; 

%Initial condition
X0=[-15/180*pi;0;0;0;0;0];
%% Feed-forward input:

Vop=0.5*g*(Lw*m_w-2*La*m_f)/(La*Kf);

sim('ClosedLoopNonLinearModel')