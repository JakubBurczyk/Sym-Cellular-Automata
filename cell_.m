classdef cell_
    properties
        state   % 1 - healthy
                % 2 - infected
                % 3 - sick
                % 4 - recovered
                % -1 - dead, UNSTABLE TRANSITION STATE (1 iteration -> % cell removed)
        pos % position on a map
        map_size
        
        age %number of iterations being alive
        mask % masks decrease chance of infection in automata class
        quarantine % quarantine decreased movement in automata class
        
        time_infected % time since infected
        time_sick % time since sick
        
        time_to_get_sick % min time since infection that is required to roll for getting sick
        time_to_recover_from_infected % min time since infection that is required to roll to recover as infected
        time_to_recover_from_sick % min time since infection that is required to roll to recover as sick
        
        probability_of_getting_sick % chance of getting sick while being infected rolled after time_to_get_sick has passed
        
        probability_of_sick_death % chance of dying as a sick cell
        probability_of_infected_recovery % chance of recovery as infected
        probability_of_sick_recovery % chance of recovery
        
        
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
            
            obj.mask = 0;
            obj.quarantine = 0;
            
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
        
        function obj = mask_on(obj)
            obj.mask = 1;
        end
        
        function obj = mask_off(obj)
            obj.mask = 0;
        end
        
        function obj = quarantine_on(obj)
            obj.quarantine = 1;
        end
        
        function obj = quarantine_off(obj)
            obj.quarantine = 0;
        end
    end
end

