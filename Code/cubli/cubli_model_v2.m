%% Cubli model:
% x(1) = face angular position
% x(2) = flywheel angular position
% x(3) = face angular velocity
% x(4) = flywheel angular velocity
function x_dot = cubli_model_v2(t,x)

    global cubli
    x_dot = zeros(length(x),1);
    hit_angle = pi/2;
    zero_thresh_angle = 1e-6;
    zero_thresh_vel = 1e-6;
    
    rebounce_factor = 1.5;
    bounce_scale_vel = rebounce_factor;
    bounce_scale_acc = rebounce_factor;
    
    % check floor hit
    if x(1) >= hit_angle || x(1) <= (hit_angle-pi)
        % check numeric zero on angle
        if abs(x(1)-hit_angle) >= zero_thresh_angle 
            if x(1) > 0
                angle = x(1)-hit_angle;
            else
                angle = x(1)-(hit_angle-pi);
            end
        else
            if x(1) > 0
                angle = (x(1)-hit_angle)/bounce_scale_vel;
            else
                angle = (x(1)-(hit_angle-pi))/bounce_scale_vel;
            end
        end
        
        % check numeric zero on velocity
        if abs(x(3)) >= zero_thresh_vel 
            vel = x(3);
        else
            vel = x(3)/bounce_scale_acc;
        end
        
        % hybrid model - hit the ground
        x_dot(1) =  (-bounce_scale_vel*angle)/cubli.simulation.Ts;
        x_dot(2) = x(4);
        
        x_dot(3) = -bounce_scale_acc*vel/cubli.simulation.Ts;
        x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw) - cubli.params.Lt*cubli.params.M*cubli.params.g*cos(x(1))*cubli.params.Iw...
                    + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);
    else
        % dynamic equations
        x_dot(1) = x(3);
        x_dot(2) = x(4);

        x_dot(3) = (cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1)) - cubli.params.u + cubli.params.Fw*x(4) - cubli.params.Fc*x(3))/cubli.params.If;
        x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw) - cubli.params.Lt*cubli.params.M*cubli.params.g*cos(x(1))*cubli.params.Iw...
                    + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);    
    end
    
end