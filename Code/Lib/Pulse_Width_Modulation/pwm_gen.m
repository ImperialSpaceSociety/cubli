function pwm_out = pwm_gen(t,fc,a)
    
    n = length(t);
    pwm_out = zeros(1,n);

    vc = a.*sin(2*pi*fc*t);
    
    for i = 1:n
        if (vc(i)>=0)
            pwm_out(i) = 1;
        else
            pwm_out(i) = 0;
        end
    end

end