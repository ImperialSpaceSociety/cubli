%% Cubli model:
% x(1) = face angular position
% x(2) = flywheel angular position
% x(3) = face angular velocity
% x(4) = flywheel angular velocity
function x_dot = cubli_model_v5(t,x)

    % Cubli global struct
    global cubli
    
    % init state vector
    x_dot = zeros(length(x),1);
    
    % (rebounce factor) = 1 + (energy renstitution factor)
    rebounce_factor = 1.5;
    bounce_scale_vel = rebounce_factor;
    bounce_scale_acc = rebounce_factor;
    
    % check floor hit
    if (x(1) >= cubli.hit_angle || x(1) <= (cubli.hit_angle-pi)) 
        
        % check numeric zero on angle
        if (abs(x(1)-cubli.hit_angle) >= cubli.zero_thresh_angle) 
            add_angle = 0;
            if x(1) > 0
                angle = x(1)-cubli.hit_angle;
            else
                angle = x(1)-(cubli.hit_angle-pi);
            end
            vel = x(3);
        else
            angle = x(1);
            vel = x(3);
            if x(1) > 0
                add_angle = cubli.hit_angle;
            else
                add_angle = pi-cubli.hit_angle;
            end
            
        end
        
        
        % hybrid model - hit the ground
        x_dot(1) =  -angle/cubli.simulation.Ts + add_angle;
        
        x_dot(2) = x(4);
        
        x_dot(3) = -vel/cubli.simulation.Ts;
        
        x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw)...
                    - cubli.params.Lt*cubli.params.M*cubli.params.g*cos(x(1))*cubli.params.Iw...
                    + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);
        
    else
        
        % dynamic equations
        x_dot(1) = x(3);
        x_dot(2) = x(4);

        x_dot(3) = (cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1)) - cubli.params.u + cubli.params.Fw*x(4) - cubli.params.Fc*x(3))/cubli.params.If;
        x_dot(4) = (cubli.params.u*(cubli.params.If + cubli.params.Iw) - cubli.params.Fw*x(4)*(cubli.params.If + cubli.params.Iw) - cubli.params.Lt*cubli.params.M*cubli.params.g*sin(x(1))*cubli.params.Iw...
                    + cubli.params.Fc*x(3)*cubli.params.Iw)/(cubli.params.If*cubli.params.Iw);    
    end
    
end