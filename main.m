clc
clear
automat = automata(50,50,49);

for i=1:100
    automat = automat.update();
    fprintf("Update cycle %i \n",i)
end
