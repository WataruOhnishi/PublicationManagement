function out = tab2fund(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
% Jtxt = textread('Japanese.txt','%s');
if strcmp(option.format,'standard')||strcmp(option.format,'md')
    for k = 1:N
        if strcmp(option.format,'md')
            out{k} = "1. ";
        end
        if option.num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.lang,'jpn') % output language
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_JP'}}),', '...
                char(tab{k,{'FundName_JP'}}),...
                ];
            if option.title
                out{k} = [char(out{k}),', ',char(tab{k,{'Title_JP'}})];
            end
            if option.date
                if strcmp(datestr(tab{k,{'From'}},'yyyy'),datestr(tab{k,{'To'}},'yyyy'))
                    out{k} = strcat(out{k},", ", string(num2str(datetime2FY(tab{k,{'From'}}))),"年度");
                else
                    out{k} = strcat(out{k},", ", string(num2str(datetime2FY(tab{k,{'From'}}))),"年度～",...
                        string(num2str(datetime2FY(tab{k,{'To'}}))),"年度");
                end
            end
            if option.amount
                out{k} = strcat(out{k},", ",string(num2str(round(tab{k,'Budget_all'}*1e-4))),"万円");
            end
            if option.role
                if tab.MemberType(k) == "principal_investigator"
                    out{k} = [char(out{k}),' (代表者)'];
                elseif tab.MemberType(k) == "coinvestigator"
                    out{k} = [char(out{k}),' (分担者)'];
                end
            end
            out{k} = strcat(char(out{k}),". ");
            
        elseif strcmp(option.lang,'eng')
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_EN'}}),', '...
                char(tab{k,{'FundName_EN'}}),...
                ];
            if option.title
                out{k} = [char(out{k}),', ',char(tab{k,{'Title_EN'}}),];
            end
            if tab.Type(k) == "principal_investigator"
                out{k} = [char(out{k}),...
                    char(', Principal investigator')...
                    ];
            elseif tab.Type(k) == "coinvestigator"
                out{k} = [char(out{k}),...
                    char(', Coinvestigator')...
                    ];
            end
            if option.date
                out{k} = [char(out{k}),', ',...
                    char(datestr(tab{k,{'From'}},'yyyy/MM/dd')),'-'...
                    char(datestr(tab{k,{'To'}},'yyyy/MM/dd'))...
                    ];
            end
            if option.amount
                out{k} = [char(out{k}),', JPY',...
                    num2str(ThousandSep(tab{k,'Budget_all'})),...
                    ];
            end

            out{k} = [char(out{k}),'. '];
        else, error('error in option.lang');
        end
        
    end
else
    error('error on option.format');
end

end
