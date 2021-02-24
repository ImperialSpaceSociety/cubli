%% define control law
function control_law

    % global struct
    global cubli

    % CONTROL ACTION

    % error definition (current angle is a time k-1)
    e = wrapToPi(cubli.stateStory(end,1)-cubli.target_angle);
    e_int = trapz(cubli.simulation.Ts,[cubli.eint_story(end) e]);
    [cubli.e_buf, e_dot] = IterativePseudoDerivative(cubli.simulation.Ts,e,1,3,0,cubli.e_buf);
    
    cubli.e_story(end+1) = e;
    cubli.edot_story(end+1) = e_dot;
    cubli.eint_story(end+1) = e_int;
    
    e_int = sum(cubli.eint_story);

    %%%%%%%%%%% control law %%%%%%%%%%%
    % enable control only if theta is between target +- thresh deg
    thresh_1 = 1; %[deg]
    thresh_1_rad = deg2rad(thresh_1);
    
    thresh_2 = 20; %[deg]
    thresh_2_rad = deg2rad(thresh_2);

    if abs(e) < thresh_1_rad
        %%%%%%%% Proportional controller on the RW %%%%%%%%%%%%   
        RW_target_angle = 0;
        e_RW = wrapToPi(cubli.stateStory(end,2)-RW_target_angle);
        K_p = 1*1e-2;
        control = K_p*e_RW;
        
        cubli.params.u = 0;
        cubli.charging = 0;
        cubli.stop = 0;
        cubli.brake_torque = 8e1;
    elseif abs(e) >= thresh_1_rad && abs(e) < thresh_2_rad
        %%%%%%%% Proportional controller %%%%%%%%%%%%
        K_p = 1*3e0;
        K_d = 1*3e-1;
        K_i = 1*2e0;
        % control
        control = K_p*e + K_d*e_dot + K_i*e_int;

        cubli.params.u = control;
        cubli.charging = 0;
        cubli.stop = 0;
        cubli.brake_torque = 1;
    elseif cubli.stateStory(end,3) == 0
        % JUMP UP ACTION
        % step
        rpm_saturation = 5e1;
        rad_saturation = rpm_saturation*pi/30;
        if abs(cubli.stateStory(end-1,2)) >= rad_saturation
           cubli.params.u = 0;
           cubli.brake_torque = 1e4;
           cubli.charging = 0;
           cubli.stop = 0;
        else
           cubli.params.u = 1e0;
           cubli.brake_torque = 1;
           cubli.charging = 1;
        end
    else
        cubli.charging = 0;
        cubli.stop = 0;
        cubli.params.u = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
