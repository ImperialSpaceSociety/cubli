%% plot section 
% this script plots the results of the simulation stored in the current workspace

% global struct with all simulation data
global cubli

% set to zero to disable this set of plots
if 1

    % open a new figure window
    figure(1)
    
    % pltot Cubli state (dim 4)
    for i=1:cubli.StateDim
    
    	% create a subplot in the figure window (4 subplots if no input, 5 otherwise)
        if cubli.input_flag == 1
            ax(i)=subplot(cubli.StateDim+1,1,i);
        else
            ax(i)=subplot(cubli.StateDim,1,i);
        end
        
        % actual data plot
        plot(cubli.simulation.time,cubli.stateStory(i,:),'LineWidth',2);
        
        % enable the grid on the subplot
        grid on
        
        % set axis label and legend
        ylabel(strcat('x_',int2str(i)));
        title('Simulation test ')
        legend(strcat('x_',int2str(i)))
    end
    
    % plot input if present
    if cubli.input_flag == 1
    	
    	% add a subplot for the input
        ax(i)=subplot(cubli.StateDim+1,1,cubli.StateDim+1);
        
        % enable grid on the subplot
        grid on
        
        % actual data plot
        plot(cubli.simulation.time,cubli.params.U,'LineWidth',2);
        
        % set title and legend
        title('Simulation test ')
        legend('input');
    end
end

% set to zero to disable this set of plots
% this section plots the xy coordinates of the COM during the motion
if 1
	% open a new figure window
	figure
	
	% actual data plot (plot x and y)
	plot(cubli.coordinates(:,1),cubli.coordinates(:,2),'bo');
	
	% set axis limits (just to maintain the scale in the xy plot)
	endpoint = 0.15;
	xlim([-endpoint endpoint])
	ylim([-endpoint endpoint])
end

