classdef cell_
    properties
        state
        pos
        map_size
        
        age
        
        time_infected
        time_sick
        
        time_to_get_sick
        
        probability_of_getting_sick
    end
    
    methods
        function obj = cell_(size,position,probability_initial_infected,time_to_get_sick,probability_of_getting_sick)
            obj.time_infected = 0;
            obj.time_sick = 0;
            obj.time_to_get_sick = time_to_get_sick;
            obj.probability_of_getting_sick = probability_of_getting_sick;
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
            % TIME PASS
            obj.age = obj.age + 1;
            
            if(obj.state == 2)
                obj.time_infected = obj.time_infected + 1;
                
                if(obj.time_infected == obj.time_to_get_sick)
                    if rand <= obj.probability_of_getting_sick
                        obj.state = 3;
                    end
                end
                
            elseif(obj.state == 3)
                obj.time_sick = obj.time_sick + 1;
            end
            % EO TIME PASS
            
        end
        
        function obj = set_infected(obj)
            if obj.state == 1
                obj.state = 2;
            end
        end
        
        
    end
end

