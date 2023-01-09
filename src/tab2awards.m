function out = tab2awards(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.lang,'jpn') % output language
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_JP'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'AwardName_JP'}}),', '...
                char(tab{k,{'Institute_JP'}}),', '...
                ];
            
%             if ~isempty(char(tab{k,{'Title_JP'}}))
%                 out{k} = [char(out{k}),...
%                     char(tab{k,{'Title_JP'}}),', '...
%                     ];
%             end
            
        elseif strcmp(option.lang,'eng')
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_EN'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'AwardName_EN'}}),', '...
                char(tab{k,{'Institute_EN'}}),', '...
                ];
            
%             if ~isempty(char(tab{k,{'Title_EN'}}))
%                 out{k} = [char(out{k}),...
%                     char(tab{k,{'Title_EN'}}),', '...
%                     ];
%             end
        else, error('error in option.lang');
        end
        
        out{k} = [char(out{k}),...
            datestr(tab{k,{'Date'}},'yyyy/mm/dd'),'.'...
            ];
        
    end
    
elseif strcmp(option.format,'latex')
    for k = 1:N
        out{k} = [num2str(k),'. & '];
        if strcmp(option.lang,'jp') % output language
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_JP'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'AwardName_JP'}}),', '...
                char(tab{k,{'Institute_JP'}}),', '...
                ];
            
            if ~isempty(char(tab{k,{'Title_JP'}}))
                out{k} = [char(out{k}),...
                    char(tab{k,{'Title_JP'}}),', '...
                    ];
            end
            
        elseif strcmp(option.lang,'en')
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_EN'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'AwardName_EN'}}),', '...
                char(tab{k,{'Institute_EN'}}),', '...
                ];
            
            if ~isempty(char(tab{k,{'Title_EN'}}))
                out{k} = [char(out{k}),...
                    char(tab{k,{'Title_EN'}}),', '...
                    ];
            end
        else, error('error in option.lang');
        end
        
        out{k} = [char(out{k}),...
            datestr(tab{k,{'Date'}},'yyyy/mm/dd'),'.'...
            ];
        out{k} = join([out{k},'\\'],'');
    end
else
    error('error on option.format');
end

end
