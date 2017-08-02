% Copyright (c) 2016, German Neuroinformatics Node (G-Node)
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted under the terms of the BSD License. See
% LICENSE file in the root of the Project.

classdef Dynamic
    % Dynamic class (with static methods hehe)
    % implements methods to dynamically assigns properties 

    methods (Static)
        function add_dyn_attr(obj, prop, mode)
            if (nargin < 3)
                mode = 'r'; 
            end

            % create dynamic property
            p = addprop(obj, prop);

            % define property accessor methods
            p.GetMethod = @get_method;
            p.SetMethod = @set_method;

            function set_method(obj, val)
                if (strcmp(mode, 'r'))
                    msg = 'You cannot set the read-only property ''%s'' of %s';
                    ME = MException('MATLAB:class:SetProhibited', msg, prop, class(obj));
                    throwAsCaller(ME);
                end

                if (isempty(val))
                    fname = strcat(obj.alias, '::setNone', upper(prop(1)), prop(2:end));
                    nix_mx(fname, obj.nix_handle, 0);
                elseif ((strcmp(prop, 'units') || strcmp(prop, 'labels')) && (~iscell(val)))
                %-- BUGFIX: Matlab crashes, if units in Tags and MultiTags
                %-- or labels of SetDimension are set using anything else than a cell.
                    msg = 'This value only supports cells.';
                    ME = MException('MATLAB:class:SetProhibited', msg);
                    throwAsCaller(ME);
                else
                    fname = strcat(obj.alias, '::set', upper(prop(1)), prop(2:end));
                    nix_mx(fname, obj.nix_handle, val);
                end
            end

            function val = get_method(obj)
                val = obj.info.(prop);
            end
        end

        function add_dyn_relation(obj, name, constructor)
            dataAttr = strcat(name, 'Data');
            data = addprop(obj, dataAttr);
            data.Hidden = true;
            obj.(dataAttr) = {};

            % adds a proxy property
            rel = addprop(obj, name);
            rel.GetMethod = @get_method;

            % same property but returns Map 
            rel_map = addprop(obj, strcat(name, 'Map'));
            rel_map.GetMethod = @get_as_map;
            rel_map.Hidden = true;

            function val = get_method(obj)
                obj.(dataAttr) = nix.Utils.fetchObjList(obj, name, constructor);
                val = obj.(dataAttr);
            end

            function val = get_as_map(obj)
                val = containers.Map();
                props = obj.(name);

                for i = 1:length(props)
                    val(props{i}.name) = cell2mat(props{i}.values);
                end
            end
        end
    end

end
