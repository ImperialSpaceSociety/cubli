%% setinput function
% input:
% pos: time index
% output:
% no output, but the current input value is stored in cubli.params.u
function set_input(pos)

    % global struct with simulation data
    global cubli
        
    % check if control input is enabled. if this is the case the 
    % input is set as the value defined in cubli_init.m (cubli.params.U vector). 
    % Otherwise set the input to zero
    if cubli.input_flag == 1
        cubli.params.u = cubli.params.U(pos);
    else
        cubli.params.u = 0;
    end
    
end
