function out = tab2fund(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
Jtxt = textread('Japanese.txt','%s');
if strcmp(option.format,'standard')
    for k = 1:N
        if option.Num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.Language,'jp') % output language
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_JP'}}),', '...
                char(tab{k,{'FundName_JP'}}),', '...
                ];
            if option.title
                out{k} = [char(out{k}),char(tab{k,{'Title_JP'}})];
            end
            if tab.MemberType(k) == '1'
                out{k} = [char(out{k}),...
                    char([', ' Jtxt{1}])...
                    ];
            elseif tab.MemberType(k) == '2'
                out{k} = [char(out{k}),...
                    char([', ' Jtxt{2}])...
                    ];
            end
            if option.date
                if strcmp(datestr(tab{k,{'From'}},'yyyy'),datestr(tab{k,{'To'}},'yyyy'))
                    out{k} = [char(out{k}),', ',...
                        num2str(datetime2FY(tab{k,{'From'}})),Jtxt{3}...
                        ];
                else
                    out{k} = [char(out{k}),', ',...
                        num2str(datetime2FY(tab{k,{'From'}})),Jtxt{4}...
                        num2str(datetime2FY(tab{k,{'To'}})),Jtxt{3}...
                        ];
                end
            end
            if option.amount
                out{k} = [char(out{k}),', ',...
                    num2str(round(tab{k,'Budget_all'}*1e-4)),Jtxt{5}...
                    ];
            end
            out{k} = [char(out{k}),'. '];
            
        elseif strcmp(option.Language,'en')
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_EN'}}),', '...
                char(tab{k,{'FundName_EN'}}),', '...
                ];
            if option.title
                out{k} = [char(out{k}),char(tab{k,{'Title_EN'}}),];
            end
            if tab.Type(k) == '1'
                out{k} = [char(out{k}),...
                    char(', Head')...
                    ];
            elseif tab.Type(k) == '2'
                out{k} = [char(out{k}),...
                    char(', Member')...
                    ];
            end
            if option.date
%                 if strcmp(datestr(tab{k,{'From'}},'yyyy'),datestr(tab{k,{'To'}},'yyyy'))
%                     out{k} = [char(out{k}),', ',...
%                         char(datestr(tab{k,{'From'}},'yyyy/MM/dd')),...
%                         ];
%                 else
                    out{k} = [char(out{k}),', ',...
                        char(datestr(tab{k,{'From'}},'yyyy/MM/dd')),'-'...
                        char(datestr(tab{k,{'To'}},'yyyy/MM/dd'))...
                        ];
%                 end
            end
            if option.amount
                out{k} = [char(out{k}),', JPY',...
                    num2str(ThousandSep(tab{k,'Budget_all'})),...
                    ];
            end
            out{k} = [char(out{k}),'. '];
        else, error('error in option.Language');
        end
        
    end
elseif strcmp(option.format,'travel')
    for k = 1:N
        if option.Num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.Language,'jp') % output language
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_JP'}}),', '...
                char(tab{k,{'FundName_JP'}}),', '...
                ];
            if option.title
                out{k} = [char(out{k}),char(tab{k,{'Title_JP'}})];
            end
            if option.amount
                out{k} = [char(out{k}),', ',...
                    num2str(round(tab{k,'Budget_all'}*1e-4)),Jtxt{5}...
                    ];
            end
            out{k} = [char(out{k}),'. '];
            
        elseif strcmp(option.Language,'en')
            out{k} = [char(out{k}),...
                char(tab{k,{'Institute_EN'}}),', '...
                char(tab{k,{'FundName_EN'}}),', '...
                ];
            if option.title
                out{k} = [char(out{k}),char(tab{k,{'Title_EN'}}),];
            end
            if option.amount
                out{k} = [char(out{k}),', JPY',...
                    num2str(ThousandSep(tab{k,'Budget_all'})),...
                    ];
            end
            out{k} = [char(out{k}),'. '];
        else, error('error in option.Language');
        end
        
    end
else
    error('error on option.format');
end

end
