classdef cell_
    properties
        state
        pos
        map_size
    end
    
    methods
        function obj = cell_(size,position)
            obj.state = 1;
            obj.map_size = size;
            obj.pos = position;
        end
        
        function obj = move(obj,new_pos)
            obj.pos = new_pos;
        end
        
        function obj = set_ill(obj)
            if obj.state == 1
                obj.state = 2;
            end
        end
        
        
    end
end

