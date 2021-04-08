classdef cell_
    properties
        state
        pos
        map_size
        
        age
        
        time_infected
        time_sick
        
        time_to_get_sick
        time_to_recover_from_infected
        time_to_recover_from_sick
        
        probability_of_getting_sick
        
        probability_of_sick_death
        probability_of_infected_recovery
        probability_of_sick_recovery
    end
    
    methods
        function obj = cell_(size,position,probability_initial_infected...
                ,time_to_get_sick, time_to_recover_from_infected, time_to_recover_from_sick...
                ,probability_of_getting_sick...
                ,probability_of_infected_recovery, probability_of_sick_recovery...
                ,probability_of_sick_death)
            
            obj.time_infected = 0;
            obj.time_sick = 0;
            
            obj.time_to_get_sick = time_to_get_sick;
            obj.time_to_recover_from_infected = time_to_recover_from_infected;
            obj.time_to_recover_from_sick = time_to_recover_from_sick;
            
            obj.probability_of_getting_sick = probability_of_getting_sick;
            obj.probability_of_infected_recovery = probability_of_infected_recovery;
            obj.probability_of_sick_recovery = probability_of_sick_recovery;
            obj.probability_of_sick_death = probability_of_sick_death;
            
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
                elseif(obj.time_infected >= obj.time_to_recover_from_infected)
                    if rand <= obj.probability_of_infected_recovery
                        obj.state = 4;
                    end
                end
                
            elseif(obj.state == 3)
                obj.time_sick = obj.time_sick + 1;
                
                if(obj.time_sick >= obj.time_to_recover_from_sick)
                    if rand <= obj.probability_of_getting_sick
                        obj.state = 4;
                    elseif rand <= obj.probability_of_sick_death
                        obj.state = -1;
                    end
                    
                end
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

