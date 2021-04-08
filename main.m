clc
clear

cycles = 300;
automat = automata(20,20,200);
stats = [0 0 0 0 0 0];

fprintf("START SIM\n")

tic()
time_start = toc();

for i=1:cycles
    pause(0.0000001)
    
    time_f_start = toc();
    automat = automat.update();
    
    stats(i,:) = automat.get_stats();
        
    time_f_end = toc();
    time_elapsed = time_f_end - time_start;
    time_elapsed_f = time_f_end - time_f_start;
    eta = time_elapsed_f * (300-i);
    
    fprintf("Update cycle %i, Elapsed: %f, F time: %f, ETA: %f \n",i,time_elapsed,time_elapsed_f,eta)
end
fprintf("END SIM\n")

figure()
plot(stats(:,1),stats(:,3)+stats(:,4));
title("ALL INFECTED AND SICK")
