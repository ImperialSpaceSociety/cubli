function Xnew  = PlantJumpMap_general_notime(X,model,forwardpropagation)
% X: state and parameters
% j: index used to retrieve the data (input) on the moving orizon window
% forwardpropagation: 1 if forward propagation, -1 otherwise
% estimate: 1 if used for the estimated plant, 0 othwerwise
% Example: x = A*x+B*u(j); j-1 is the index used to select input value

global cubli

x0 = X(1:cubli.StateDim);
tjunk = 0;

if(forwardpropagation == 1) 
    x = x0 + model(tjunk,x0)*cubli.simulation.Ts;
else
    x = x0 - model(tjunk,x0)*cubli.simulation.Ts;
end

Xnew = x;