function x_dot = cubli_model(t,x)

    global cubli
    x_dot = zeros(length(x),1);
    
   
    % dynamic equations
    x_dot(1) = x(3);
    x_dot(2) = x(4);

    x_dot(3) = (cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1)) - cubli.params.u + cubli.params.Fw*x(4) - cubli.params.Fc*x(3))/cubli.params.If;
    x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw) - cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1))*cubli.params.Iw...
                + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);   
end