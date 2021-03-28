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
        
        function draw(obj)
            clf(obj.fig)
            hold on
            for i=1:obj.size(1)
                for j = 1:obj.size(2)
                    switch obj.grid(i,j)
                        case 0
%                             color = [1 1 1];
                            continue;
                        case 1
                            color = [0.4660 0.6740 0.1880];
                        case 2
                            color = [0.6350 0.0780 0.1840];
                        case 3
                            color = [0.3010 0.7450 0.9330];
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
            hold off
        end

    end

    
end

