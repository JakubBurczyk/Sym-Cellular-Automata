classdef cell_
    properties
        state
        pos
        map_size
        age
    end
    
    methods
        function obj = cell_(size,position)
            obj.state = 1;
            obj.map_size = size;
            obj.pos = position;
            obj.age = 0;
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

