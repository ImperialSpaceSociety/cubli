function Xnew  = PlantJumpMap_hybrid(X,model,forwardpropagation)
% X: state and parameters
% j: index used to retrieve the data (input) on the moving orizon window
% forwardpropagation: 1 if forward propagation, -1 otherwise
% estimate: 1 if used for the estimated plant, 0 othwerwise
% Example: x = A*x+B*u(j); j-1 is the index used to select input value

global cubli

x0 = X(1:cubli.StateDim);
tjunk = 0;
cubli.x_old = x0;

if (x0(1) >= cubli.hit_angle || x0(1) <= (cubli.hit_angle-pi)) 
    cubli.hit = 1;
    x0(1) = 0;
    x0(3) = 0;
else
    cubli.hit = 0;
end

if(forwardpropagation == 1) 
    x = x0 + model(tjunk,x0)*cubli.simulation.Ts;
else
    x = x0 - model(tjunk,x0)*cubli.simulation.Ts;
end

Xnew = x;