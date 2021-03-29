clc
clear
automat = automata(20,20,50);

for i=1:400
    pause(0.0001)
    automat = automat.update();
    fprintf("Update cycle %i \n",i)
end
