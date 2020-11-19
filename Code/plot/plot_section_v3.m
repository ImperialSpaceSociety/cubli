%% plot section 

global cubli

%% plant test
if 1
    figure(1)
    % state
    for i=1:cubli.StateDim
        if cubli.input_flag == 1
            ax(i)=subplot(cubli.StateDim+1,1,i);
        else
            ax(i)=subplot(cubli.StateDim,1,i);
        end
        plot(cubli.simulation.time,cubli.stateStory(i,:),'LineWidth',2);
        grid on
        ylabel(strcat('x_',int2str(i)));
        title('Simulation test ')
        legend(strcat('x_',int2str(i)))
    end
    
    % input
    if cubli.input_flag == 1
        ax(i)=subplot(cubli.StateDim+1,1,cubli.StateDim+1);
        grid on
        plot(cubli.simulation.time,cubli.params.U,'LineWidth',2);
        title('Simulation test ')
        legend('input');
    end
end

figure
plot(cubli.coordinates(:,1),cubli.coordinates(:,2),'bo');
xlim([-1.5 1.5])
ylim([-1.5 1.5])

