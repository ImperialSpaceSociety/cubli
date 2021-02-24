function [position,isterminal,direction] = ODEstop(t,x)
    % globa vars
    global cubli

    % If Y=0 then cond_1 goes to zero (hit the ground)
    if  (abs(x(1)) < cubli.hit_angle)
        cond_1 = 1;
    else
        cond_1 = 0;
    end
    
    % as soon as position goes to zero the integration stops (hit something)
    position = cond_1; 
    
    % Halt integration 
    isterminal = 1;  
    
    % The zero can be approached from either direction
    direction = -1;   
end