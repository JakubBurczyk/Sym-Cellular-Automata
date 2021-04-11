classdef automata
    
    properties
        grid
        cells_
        iter
        
        dead
        startpop
        
        % PARAMS
        time_to_get_sick
        time_to_recover_from_infected
        time_to_recover_from_sick
        
        move_coeff_infected
        move_coeff_sick
        
        probability_initial_infected
        
        probability_of_infecton_per_sick_neighbour
        probability_of_getting_sick
        probability_of_recovery
        probability_of_sick_death
        probability_of_infected_recovery
        probability_of_sick_recovery
        % END PARAMS
        
        enforced_masks
        enforced_lockdown
    end
    
    methods
        
        function obj = automata(size_x,size_y,start_population)
            % SETNUMERICAL PARAMS
            obj.time_to_get_sick = 15;
            obj.time_to_recover_from_infected = 15;
            obj.time_to_recover_from_sick = 25;
            obj.probability_of_getting_sick = 0.5;
            obj.probability_initial_infected = 0.02;
            obj.probability_of_infecton_per_sick_neighbour = 0.25;
            
            obj.move_coeff_infected = 0.8;
            obj.move_coeff_sick = 0.5;
            
            obj.probability_of_sick_recovery = 0.05;
            obj.probability_of_infected_recovery = 0.1;
            obj.probability_of_sick_death = 0.2;
            
            
            % END NUMERICAL PARAMS
            obj.dead = 0;
            obj.enforced_masks = 0;
            obj.enforced_lockdown = 0;
            
            %INIT
            obj.grid = cell_grid(size_x,size_y);
            obj.cells_ = cell_.empty(0,start_population);
            obj.iter = 0;
            
            %saving initial cell positions to 'positions' (init [0,0])  
            %every row corresponds to one location, col(1) = x, col(2) = y
            positions = [0,0];
            regens = 0;
            for i = 1:start_population
                flag_same_pos = 0;
                pos(1) = randi([1,obj.grid.size(1)],1); %rand x
                pos(2) = randi([1,obj.grid.size(2)],1); %rand y
                
                len = size(positions); % ROWSxCOLS of positions matrix
                len  = len(1); %number of occupied locations
                
                %for every occupied location
                for j = 1:len
                    %if randomised location is already occupied set a flag
                    %and redo 1 iteration (i-1) to maintain initial
                    %starting population
                    
                    if (pos(1) == positions(j,1)) && (pos(2)== positions(j,2))
                        flag_same_pos = 1;
                        %fprintf("Re-Gen position\n")
                        start_population = start_population + 1;
                        regens = regens + 1;
                        break;
                    end
                end
                %if location is not occupied (flag is FALSE)
                %add location to occupied 'positions' and generate cell
                %with given position
                if flag_same_pos == 0
                    positions(i-regens,1) = pos(1);
                    positions(i-regens,2) = pos(2);
                    obj.cells_(i-regens) = cell_(obj.grid.size,pos,...
                        obj.probability_initial_infected,obj.time_to_get_sick,...
                        obj.time_to_recover_from_infected, obj.time_to_recover_from_sick,...
                        obj.probability_of_getting_sick,...
                        obj.probability_of_infected_recovery, obj.probability_of_sick_recovery,...
                        obj.probability_of_sick_death);
                end
            end
            
            obj.startpop = length(obj.cells_);
            
            %initial grid representation
            for i = 1:length(obj.cells_)
                obj.grid = obj.grid.set_state(obj.cells_(i).pos,obj.cells_(i).state);
            end
        end
        
        function obj = update(obj)
            obj.iter = obj.iter + 1;
            
            obj = obj.cells_check_infected();
            
            obj = obj.cells_move();
            
            obj.grid = obj.grid.reset();
            
            cells_to_remove = [];
            for i = 1:length(obj.cells_)
                obj.cells_(i) = obj.cells_(i).update();
                
                if obj.cells_(i).state == -1
                    cells_to_remove(end+1) = i;
                    obj.dead = obj.dead + 1;
                end
                
                obj.grid = obj.grid.set_state(obj.cells_(i).pos,obj.cells_(i).state);
            end
            
            for i = length(cells_to_remove):-1:1
                obj.cells_(cells_to_remove(i)) = [];
            end
%             obj.grid.draw_cells(obj.iter,obj.cells_,obj.startpop,obj.dead)

            
        end
        
        function obj = cells_move(obj)
            % Target is chosen based on randomized direction vector
            for i=1:length(obj.cells_)
                
                
                target = [randi([-1,1],1) ,randi([-1,1],1)];
                
                %lockdown cuts movement BY HALF!
                if (obj.cells_(i).quarantine == 1) && (rand <= 0.5)
                    target = [0 0];
                end
                
                %infected cells move a little slower
                if (obj.cells_(i).state == 2) && (rand <= obj.move_coeff_infected)
                    target = [0 0];
                end
                
                %sick cells move significantly slower
                if (obj.cells_(i).state == 3) && (rand <= obj.move_coeff_sick)
                    target = [0 0];
                end
                
                
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
                    %clearing old position on grid
                    obj.grid = obj.grid.set_state(obj.cells_(i).pos,0);
                    
                    %setting cells position to a new one
                    obj.cells_(i) = obj.cells_(i).move(target_pos);
                    
                    %setting new grid position-state
                    obj.grid = obj.grid.set_state(target_pos,obj.cells_(i).state);
%                     fprintf("Moved cell to %i %i \n",obj.cells_(i).pos(1),obj.cells_(i).pos(2))
                end
            end
        end
        
        function obj = cells_check_infected(obj)
            
            for i=1:length(obj.cells_)
                if obj.cells_(i).state == 1
                    sick_neighbours = obj.grid.check_infected_neighbours(obj.cells_(i).pos);
                    
                    enforce_modifier = 1;   % modifier changing probability of getting infected
                                            % for example wearing masks see below
                    
                    if obj.cells_(i).mask == 1
                        enforce_modifier = 0.5;
                    end
                    
                    if rand <= sick_neighbours * obj.probability_of_infecton_per_sick_neighbour * enforce_modifier
                        obj.cells_(i) = obj.cells_(i).set_infected();
                    end
                end
            end
        end
        
        
        function stats = get_stats(obj)
            %returns a vector of statistics
            healthy = 0;
            infected = 0;
            sick = 0;
            recovered = 0;
            
            for i=1:length(obj.cells_)
                switch obj.cells_(i).state
                    case 1
                        healthy = healthy + 1;
                    case 2
                        infected = infected + 1;
                    case 3
                        sick = sick + 1;
                    case 4
                        recovered = recovered + 1;
                end
            end
            
            stats = [obj.iter, healthy, infected, sick, recovered, obj.dead];
            
        end
        
        % global countermeasures
        % masks change probability modifierc in method cells_check_infected
        function obj = enforce_masks(obj)
            obj.enforced_masks = 1;
            for i=1:length(obj.cells_)
                obj.cells_(i) = obj.cells_(i).mask_on();
                
            end
        end
        
        function obj = revoke_masks(obj)
            obj.enforced_masks = 0;
            for i=1:length(obj.cells_)
                obj.cells_(i) = obj.cells_(i).mask_off();
                
            end
        end
        
        % lockdown (global quarantine) changes movement coefficients in
        % cells_move
        function obj = enforce_lockdown(obj)
            obj.enforced_lockdown = 1;
            for i=1:length(obj.cells_)
                obj.cells_(i) = obj.cells_(i).quarantine_on();
            end
        end
        
        function obj = revoke_lockdown(obj)
            obj.enforced_lockdown = 0;
            for i=1:length(obj.cells_)
                obj.cells_(i) = obj.cells_(i).quarantine_off();
            end
        end
    end
end

