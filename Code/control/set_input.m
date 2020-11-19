function set_input(pos)

    global cubli
        
    % system control input
    if cubli.input_flag == 1
        cubli.params.u = cubli.params.U(pos);
    else
        cubli.params.u = 0;
    end
    
    % check if stop is an option
    time_index = pos-1;
    if  (abs(cubli.stateStory(3,time_index)) <= cubli.zero_thresh_vel)
        cubli.stateStory(3,time_index) = 0;
        cubli.stop_flag = 1;
    else
        cubli.stop_flag = 0;
    end
end