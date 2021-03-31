clc
clear

automat = automata(50,50,180);
stats = [0 0 0 0 0];
fprintf("START\n")
for i=1:500
    pause(0.0000001)
    automat = automat.update();
    
    if mod(i,5) == 0 
        stats(floor(i/5),:) = automat.get_stats();
    end
    
    fprintf("Update cycle %i \n",i)
end
figure()
plot(stats(:,1),stats(:,3)+stats(:,4));
fprintf("END\n")