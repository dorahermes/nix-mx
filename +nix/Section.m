classdef Section < nix.Entity
    %SECTION Metadata Section class
    %   NIX metadata section
    
    properties(Hidden)
        info
        sectionsCache
    end;
    
    properties(Dependent)
        name
        type
        id
        repository
        mapping
        
        sections
        props
    end;
    
    methods
        function obj = Section(h)
           obj@nix.Entity(h);
           obj.info = nix_mx('Section::describe', obj.nix_handle);
           
           obj.sectionsCache.lastUpdate = 0;
           obj.sectionsCache.data = {};
        end;
        
        function name = get.name(section)
           name = section.info.name;
        end;
        
        function id = get.id(section)
           id = section.info.id;
        end;
        
        function type = get.type(section)
           type = section.info.type;
        end;
        
        function repository = get.repository(section)
           repository = section.info.repository;
        end;
        
        function mapping = get.mapping(section)
           mapping = section.info.mapping;
        end;

        function section = parent(obj)
           sh = nix_mx('Section::parent', obj.nix_handle);
           try
               section = nix.Section(sh);
           catch
               section = {};
           end;
        end;
        
        function section = link(obj)
           sh = nix_mx('Section::link', obj.nix_handle);
           try
               section = nix.Section(sh);
           catch
               section = {};
           end;
        end;
        
        % ----------------
        % Section methods
        % ----------------
        
        function lst = list_sections(obj)
            lst = nix_mx('Section::listSections', obj.nix_handle);
        end;
        
        function sections = get.sections(obj)
            [obj.sectionsCache, sections] = nix.Utils.fetchObjList(obj.updatedAt, ...
                'Section::sections', obj.nix_handle, obj.sectionsCache, @nix.Section);
        end
        
        function section = open_section(obj, id_or_name)
           sh = nix_mx('Section::openSection', obj.nix_handle, id_or_name); 
           section = nix.Section(sh);
        end;
        
        function hs = has_section(obj, id_or_name)
            r = nix_mx('Section::hasSection', obj.nix_handle, id_or_name);
            hs = logical(r.hasSection);
        end;
        
        % ----------------
        % Property methods
        % ----------------
        
        function props = get.props(obj)
            props = nix_mx('Section::listProperties', obj.nix_handle);
        end
    end
    
end

