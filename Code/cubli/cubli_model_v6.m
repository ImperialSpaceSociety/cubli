%% Cubli model:
% x(1) = face angular position
% x(2) = flywheel angular position
% x(3) = face angular velocity
% x(4) = flywheel angular velocity
function x_dot = cubli_model_v6(t,x)

    % Cubli global struct
    global cubli
    
    % init state vector
    x_dot = zeros(length(x),1);
    
    % check floor hit
    if cubli.hit == 1 && cubli.brake == 0
        
        % (rebounce factor) = 1 + (energy renstitution factor)
        if abs(cubli.x_old(3)) > cubli.zero_thresh_vel
            rebounce_factor = 0.5;
        else
            rebounce_factor = 0;
        end
        
        if cubli.x_old(1) > 0
            if rebounce_factor ~= 0
                angle = (1-2*cubli.zero_thresh_angle)*cubli.hit_angle;
            else
                angle = cubli.hit_angle;
            end
        else
            if rebounce_factor ~= 0
                angle = (1-2*cubli.zero_thresh_angle)*(cubli.hit_angle-pi);
            else
                angle = (cubli.hit_angle-pi);
            end
        end
        
        % hybrid model - hit the ground
        x_dot(1) = angle/cubli.simulation.Ts;
        
        x_dot(2) = x(4);
        
        x_dot(3) = -cubli.x_old(3)*rebounce_factor/cubli.simulation.Ts;
        
        x_dot(4) = cubli.params.u/cubli.simulation.Ts;
        
    else
        
        % dynamic equations
        
        if cubli.brake == 0
            x_dot(1) = x(3);
            x_dot(3) = (cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1)) - cubli.params.u + cubli.params.Fw*x(4) - cubli.params.Fc*x(3))/cubli.params.If;
            x_dot(2) = x(4);
            x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw) - cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1))*cubli.params.Iw...
                       + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);    
        else
            x_dot(1) = x(3);
            x_dot(3) = (- cubli.params.u + cubli.params.Fw*x(4) - cubli.params.Fc*x(3))/cubli.params.If;
            x_dot(2) = x(4);
            x_dot(4) = -cubli.brake_torque*x(4); 
        end
    end
    
end