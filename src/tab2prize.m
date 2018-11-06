function out = tab2prize(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.Num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.Language,'jp') % output language
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_JP'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'PrizeName_JP'}}),', '...
                char(tab{k,{'Institute_JP'}}),', '...
                ];
            
            if ~isempty(char(tab{k,{'Title_JP'}}))
                out{k} = [char(out{k}),...
                    char(tab{k,{'Title_JP'}}),', '...
                    ];
            end
            
        elseif strcmp(option.Language,'en')
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_EN'}}),', '];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'PrizeName_EN'}}),', '...
                char(tab{k,{'Institute_EN'}}),', '...
                ];
            
            if ~isempty(char(tab{k,{'Title_EN'}}))
                out{k} = [char(out{k}),...
                    char(tab{k,{'Title_EN'}}),', '...
                    ];
            end
        else, error('error in option.Language');
        end
        
        out{k} = [char(out{k}),...
            datestr(tab{k,{'Date'}},'yyyy/mm/dd'),'.'...
            ];
        
    end
else
    error('error on option.format');
end

end
