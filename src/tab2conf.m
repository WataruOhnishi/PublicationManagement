function out = tab2conf(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.lang,'jp') % output language
            if option.name
                out{k} = [char(out{k}),char(tab{k,{'Name_JP'}}),', '];
            end
            if ~isempty(char(tab{k,{'Title_JP'}}))
                out{k} = [char(out{k}),...
                    char(tab{k,{'Title_JP'}}),', '...
                    ];
            end
            out{k} = [char(out{k}),...
                char(tab{k,{'Host_JP'}}),', '...
                ];
            
            
        elseif strcmp(option.lang,'en')
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
        else, error('error in option.lang');
        end
        
        out{k} = [char(out{k}),...
            datestr(tab{k,{'Date'}},'yyyy/mm/dd'),'.'...
            ];
        
    end
else
    error('error on option.format');
end

end
