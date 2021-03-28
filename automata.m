classdef automata
    
    properties
        grid
        cells_
    end
    
    methods
        function obj = automata(size_x,size_y,start_population)
            obj.grid = cell_grid(size_x,size_y);
            obj.cells_ = cell_.empty(0,start_population);
            
            positions = [0,0];
            for i = 1:start_population
                flag_same_pos = false;
                pos(1) = randi([1,obj.grid.size(1)],1); 
                pos(2) = randi([1,obj.grid.size(2)],1);
                
                len = size(positions);
                len  = len(1);
                for j = 1:len
                    if (pos(1) == positions(j,1)) && (pos(2)== positions(j,2))
                        flag_same_pos = true;
                        i = i -1;
                        break;
                    end
                end
                
                if ~flag_same_pos
                    positions(i,1) = pos(1);
                    positions(i,2) = pos(2);
                    obj.cells_(i) = cell_(obj.grid.size,pos);
                end
            end
            
            for i = 1:length(obj.cells_)
                obj.grid = obj.grid.set_state(obj.cells_(i).pos,obj.cells_(i).state);
            end
            
            
            
        end
        
        function obj = update(obj)
            
            obj = obj.cells_move();
            
            obj.grid = obj.grid.reset();
            
            for i = 1:length(obj.cells_)
                obj.grid = obj.grid.set_state(obj.cells_(i).pos,obj.cells_(i).state);
            end
            
            obj.grid.draw()
            
        end
        
        function obj = cells_move(obj)
            % Target is chosen based on randomized direction vector
            for i=1:length(obj.cells_)
                target = [randi([-1,1],1) ,randi([-1,1],1)];
                target_pos = obj.cells_(i).pos + target;
                
                if target_pos(1) > obj.grid.size(1)
                    target_pos(1) = obj.grid.size(1);
                elseif target_pos(1) < 1
                    target_pos(1) = 1;
                end
                
                if target_pos(2) > obj.grid.size(2)
                    target_pos(2) = obj.grid.size(2);
                elseif target_pos(2) < 1
                    target_pos(2) = 1;
                end
                    
                if obj.grid.is_empty(target_pos)
                    obj.cells_(i) = obj.cells_(i).move(target_pos);
%                     fprintf("Moved cell to %i %i \n",obj.cells_(i).pos(1),obj.cells_(i).pos(2))
                end
            end
        end
        
    end
end

