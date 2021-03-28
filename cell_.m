classdef cell_
    properties
        state
        pos
        map_size
        age
    end
    
    methods
        function obj = cell_(size,position)
           
            obj.map_size = size;
            obj.pos = position;
            obj.age = 0;
            
            initial_sick_probability = 0.05;
            
            if rand <= initial_sick_probability
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
        
        function obj = set_ill(obj)
            if obj.state == 1
                obj.state = 2;
            end
        end
        
        
    end
end

