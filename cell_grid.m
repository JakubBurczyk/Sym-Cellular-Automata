classdef cell_grid

    properties
        size
        grid
        fig
        ax
    end
    
    methods
        function obj = cell_grid(size_x,size_y)
            obj.size = [size_x, size_y];
            obj.grid = zeros(obj.size);
            obj.fig = figure;
            obj.ax = axes;
            obj.fig.WindowState = 'maximized';
            
        end
        
        function obj = reset(obj)
            obj.grid = zeros(obj.size);
        end
        
        function obj = set_state(obj, pos, state)
            if ismember(state,0:3)
                obj.grid(pos(1),pos(2)) = state;
            end
        end
        
        function empty  = is_empty(obj,pos)
            if obj.grid(pos(1),pos(2)) == 0
                empty = true;
            else
                empty = false;
            end
        end
        
        function sick = check_infected_neighbours(obj,pos)
            sick = 0;
            targ = [pos + [-1 1 ]; %Left Up     1
                    pos + [-1 0 ]; %Left Mid    2
                    pos + [-1 -1]; %Left Down   3
                    pos + [ 0 1 ]; %Cent Up     4
                    pos + [ 0 -1 ];%Cent Down   5
                    pos + [ 1 1 ]; %Righ Up     6
                    pos + [ 1 0 ]; %Righ Mid    7
                    pos + [ 1 -1];];%Righ Down  8
            
            %disable targets depending on cell border pos
            %Left
            if pos(1) == 1
                 targ(1,:) = pos;
                 targ(2,:) = pos;
                 targ(3,:) = pos;
                 %Down corner
                 if pos(2) == 1
                    targ(5,:) = pos;
                    targ(8,:) = pos;
                 %Up corner
                 elseif pos(2) == obj.size(2)
                    targ(4,:) = pos;
                    targ(6,:) = pos;
                 end
            %Right
            elseif pos(1) == obj.size(1)
                 targ(6,:) = pos;
                 targ(7,:) = pos;
                 targ(8,:) = pos;
                 %Down corner
                 if pos(2) == 1
                    targ(3,:) = pos;
                    targ(5,:) = pos;
                 %Up corner
                 elseif pos(2) == obj.size(2)
                    targ(1,:) = pos;
                    targ(4,:) = pos;
                 end
            %Down
            elseif pos(2) == 1
                 targ(3,:) = pos;
                 targ(5,:) = pos;
                 targ(8,:) = pos;
            %Up
            elseif pos(2) == obj.size(2)
                 targ(1,:) = pos;
                 targ(4,:) = pos;
                 targ(6,:) = pos;
            end
            
            len = size(targ);
            len = len(2);
            for i=1:len
                sick = sick + obj.is_infected([targ(i,1),targ(i,2)]);
            end
        end
        
        function infected  = is_infected(obj,pos)
            if ((obj.grid(pos(1),pos(2)) == 2) || (obj.grid(pos(1),pos(2)) == 3))
                infected = 1;
            else
                infected = 0;
            end
        end
        
        function draw(obj,iter)
            clf(obj.fig)
            hold on
            alive = 0;
            infected = 0;
            sick = 0;
            recovered = 0;
            
            for i=1:obj.size(1)
                for j = 1:obj.size(2)
                    switch obj.grid(i,j)
                        case 0
%                             color = [1 1 1];
                            continue;
                        case 1
                            color = [0.4660 0.6740 0.1880];
                            alive = alive + 1;
                        case 2
                            color = [0.6350 0.0780 0.1840];
                            infected = infected + 1;
                        case 3
                            color = [1 0 0];
                            sick = sick + 1;
                    end
                    x = [i-0.5, i-0.5, i+0.5, i+0.5];
                    y = [j-0.5, j+0.5, j+0.5, j-0.5];
                    fill(x,y,color)
                end
            end
            axis([0.5,obj.size(1)+0.5,0.5,obj.size(2)+0.5])
%             xticks([1:obj.size(1)])
%             yticks([1:obj.size(2)])
            xticks([])
            yticks([])
            
            title(sprintf("Iter: %i     Alive: %i\n Infected: %i    Sick: %i",iter,alive,infected,sick))
            hold off
        end
        
        function draw_cells(obj,iter,cells)
            
            clf(obj.fig)
            hold on
            
            alive = 0;
            infected = 0;
            sick = 0;
            recovered = 0;
            
            for i=1:length(cells)

                p1 = cells(i).pos(1);
                p2 = cells(i).pos(2);
                
                switch cells(i).state
                    case 1
                        color = [0.4660 0.6740 0.1880];
                        alive = alive + 1;
                    case 2
                        color = [0.6350 0.0780 0.1840];
                        infected = infected + 1;
                    case 3
                        color = [1 0 0];
                        sick = sick + 1;
                    case 4
                        color = [0 0 1];
                        recovered = recovered + 1;
                    case -1
                        color = [0 0 0];
                        
                end
                x = [p1-0.5, p1-0.5, p1+0.5, p1+0.5];
                y = [p2-0.5, p2+0.5, p2+0.5, p2-0.5];
                fill(x,y,color)
            end
 
            axis([0.5,obj.size(1)+0.5,0.5,obj.size(2)+0.5])
            xticks([])
            yticks([])
            
            title(sprintf("Iter: %i\n Alive: %i    Recovered: %i\n Infected: %i    Sick: %i",iter,alive,recovered,infected,sick))
            hold off
        end

    end

    
end

