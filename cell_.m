classdef cell_
    properties
        state
        pos
        map_size
        age
    end
    
    methods
        function obj = cell_(size,position,probability_initial_infected)
           
            obj.map_size = size;
            obj.pos = position;
            obj.age = 0;
            
            if rand <= probability_initial_infected
                obj.state = 2;
            else
                obj.state = 1;
            end
            
        end
        
        function obj = move(obj,new_pos)
            obj.pos = new_pos;
        end
        
        function obj = update(obj)
            obj.age = obj.age + 1;
        end
        
        function obj = set_infected(obj)
            if obj.state == 1
                obj.state = 2;
            end
        end
        
        
    end
end

