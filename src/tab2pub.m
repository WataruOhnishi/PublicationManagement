function out = tab2pub(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.num % with number?
            out{k} = ['[',num2str(k),'] '];
        end
        if strcmp(option.lang,'jp') % output language
            if option.paperTitle
                out{k} = join([out{k},tab{k,{'Author_JP'}},': ',...
                    tab{k,{'Title_JP'}},', '...
                    tab{k,{'Journal_JP'}},', '...
                    ],'');
            else
                out{k} = join([out{k},tab{k,{'Author_JP'}},': ',...
                    tab{k,{'Journal_JP'}},', '...
                    ],'');
            end
        elseif strcmp(option.lang,'en')
            if option.paperTitle
                out{k} = join([out{k},tab{k,{'Author_EN'}},': ',...
                    tab{k,{'Title_EN'}},', '...
                    tab{k,{'Journal_EN'}},', '...
                    ],'');
            else
                out{k} = join([out{k},tab{k,{'Author_JP'}},': ',...
                    tab{k,{'Journal_JP'}},', '...
                    ],'');
            end
        else, error('error in option.lang');
        end
        
        if tab{k,{'Vol'}} ~= ''
            out{k} = join([out{k},'Vol. ',(tab{k,{'Vol'}}),', '],'');
        end
        
        if tab{k,{'No'}} ~= ''
            out{k} = join([out{k},'No. ',(tab{k,{'No'}}),', '],'');
        end
        
        if tab{k,{'Page_ST'}} ~= ''
            out{k} = join([out{k},'pp. ',(tab{k,{'Page_ST'}}),...
                '-',(tab{k,{'Page_ED'}}),', '],'');
        end
        
        out{k} = join([out{k},year(tab{k,{'Year'}}),'.'],'');
        
        if tab{k,'Review'} == 'accepted' % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif tab{k,'Review'} == 'submitted'
            out{k} = join([out{k},' (submitted)'],'');
        end
        
        if option.inJP
            if tab{k,'Language'} == 'ja'
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
elseif strcmp(option.format,'utoversea')
    for k = 1:N
        out{k} = ['[',num2str(k),'] '];
        out{k} = join([out{k},tab{k,{'Author_JP'}},': ',...
            tab{k,{'Title_JP'}},', '...
            tab{k,{'Journal_JP'}},', '...
            ],'');
        out{k} = join([out{k},'Vol. ',(tab{k,{'Vol'}}),', '],'');
        out{k} = join([out{k},'No. ',(tab{k,{'No'}}),', '],'');
        out{k} = join([out{k},'pp. ',(tab{k,{'Page_ST'}}),...
            '-',(tab{k,{'Page_ED'}}),', '],'');
        out{k} = join([out{k},year(tab{k,{'Year'}}),'.'],'');
        if tab{k,'Review'} == 'accepted' % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif tab{k,'Review'} == 'submitted'
            out{k} = join([out{k},' (submitted)'],'');
        end
    end
elseif strcmp(option.format,'latex')
    for k = 1:N
        out{k} = [num2str(k),'. & '];
        out{k} = join([out{k},underline(tab{k,{'Author_JP'}}),': ',...
            tab{k,{'Title_JP'}},', '...
            tab{k,{'Journal_JP'}},', '...
            ],'');
        if tab{k,{'Vol'}} ~= ''
            out{k} = join([out{k},'Vol. ',(tab{k,{'Vol'}}),', '],'');
        end
        
        if tab{k,{'No'}} ~= ''
            out{k} = join([out{k},'No. ',(tab{k,{'No'}}),', '],'');
        end
        
        if tab{k,{'Page_ST'}} ~= ''
            out{k} = join([out{k},'pp. ',(tab{k,{'Page_ST'}}),...
                '-',(tab{k,{'Page_ED'}}),', '],'');
        end
        out{k} = join([out{k},year(tab{k,{'Year'}}),'.'],'');
        if tab{k,'Review'} == 'accepted' % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif tab{k,'Review'} == 'submitted'
            out{k} = join([out{k},' (submitted)'],'');
        end
        out{k} = join([out{k},'\\'],'');
    end
else
    error('error on option.format');
end

end
