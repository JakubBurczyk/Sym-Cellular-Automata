clc
clear
automat = automata(100,100,50);

for i=1:100
    pause(0.0001)
    automat = automat.update();
    fprintf("Update cycle %i \n",i)
end
