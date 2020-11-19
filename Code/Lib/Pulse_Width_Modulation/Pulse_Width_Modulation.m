% Theory
% Pulse Width Modulation
% Pulse-width modulation (PWM), or pulse-duration modulation (PDM) is a modulation technique that conforms
% the width of the pulse, formally the pulse duration, based on a modulator signal information. Although this modulation 
% technique can be used to encode information for transmission, its main use is to allow the control of the power supplied
% to electrical devices, especially to inertial loads such as motors. The average value of voltage (and current) fed to the 
% load is controlled by turning the switch between supply and load on and off at a fast pace. The longer the switch is on 
% compared to the off periods, the higher the power supplied to the load is.
% The PWM switching frequency has to be much faster than what would affect the load, which is to say the device that
% uses the power. Typically switchings have to be done several times a minute in an electric stove, 120 Hz in a lamp
% dimmer, from few kilohertz (kHz) to tens of kHz for a motor drive and well into the tens or hundreds of kHz in audio
% amplifiers and computer power supplies.
% The term duty cycle describes the proportion of 'on' time to the regular interval or 'period' of time; a low duty cycle
% corresponds to low power, because the power is off for most of the time. Duty cycle is expressed in percent, 100%
% being fully on.
% The main advantage of PWM is that power loss in the switching devices is very low. When a switch is off there is
% practically no current, and when it is on, there is almost no voltage drop across the switch. Power loss, being the
% product of voltage and current, is thus in both cases close to zero. PWM also works well with digital controls, which,
% because of their on/off nature, can easily set the needed duty cycle.
% PWM has also been used in certain communication systems where its duty cycle has been used to convey information over a 
% communications channel.
% 
clc;
clear all;
t = 0:0.001:1;
fc = input('Enter the Frequency of Carrier Signal (Sawtooth) = ');
fm = input('Enter the Frequency of Message Signal (Sinusoidal) = ');
a = input('Enter the Amplitude of Carrier Signal = ');
b = input('Enter the Amplitude of Message Signal(should be < Carrier) = ');

vc = a.*sawtooth(2*pi*fc*t);
vm = b.*sin(2*pi*fm*t);
n = length(vc);
for i = 1:n
    if (vm(i)>=vc(i))
        pwm(i) = 1;
    else
        pwm(i) = 0;
    end
end

% Representation of the Message Signal
subplot(3,1,1);
plot(t,vm,'black');
xlabel('Time ----->');
ylabel('Amplitude ----->');
title('Message Signal');
legend('Message Signal ---->');
grid on;

% Representation of the Carrier Signal
subplot(3,1,2);
plot(t,vc);
xlabel('Sample ----->');
ylabel('Amplitude ----->');
title('Carrier Signal');
legend('Carrier Signal ---->');
grid on;

% Representation of the PWM Signal
subplot(3,1,3);
plot(t,pwm,'red');
xlabel('Sample ----->');
ylabel('Amplitude ----->');
title('PWM Signal');
legend('PWM Signal ---->');
axis([0 1 0 2]);
grid on;

% Add title to the Overall Plot
ha = axes ('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text (0.5, 1,'\bf Pulse Width Modulation ','HorizontalAlignment','center','VerticalAlignment', 'top')

