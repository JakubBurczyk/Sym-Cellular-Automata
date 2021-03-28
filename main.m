clc
clear
automat = automata(20,20,15);

for i=1:100
    pause(0.0001)
    automat = automat.update();
    fprintf("Update cycle %i \n",i)
end
