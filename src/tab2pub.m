function out = tab2pub(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.num % with number?
            out{k} = string(['[',num2str(k),'] ']);
        end
        if strcmp(option.lang,'jp') % output language
            out{k} = strcat(out{k},tab{k,{'Author_JP'}},": ",...
                tab{k,{'Title_JP'}},", ",...
                tab{k,{'Journal_JP'}},", "...
                );
        elseif strcmp(option.lang,'en')
            out{k} = strcat(out{k},tab{k,{'Author_EN'}},": ",...
                tab{k,{'Title_EN'}},", ",...
                tab{k,{'Journal_EN'}},", "...
                );
        else, error('error in option.lang');
        end
        
        if ~isempty(tab{k,{'Vol'}}) && ~isnan(tab{k,{'Vol'}})
            out{k} = strcat(out{k},"Vol. ",string(tab{k,{'Vol'}}),", ");
        end
        
        if ~isempty(tab{k,{'No'}}) && ~isnan(tab{k,{'No'}})
            out{k} = strcat(out{k},'No. ',string(tab{k,{'No'}}),", ");
        end
        
        if ~isempty(tab{k,{'Page_ST'}}) && ~isnan(tab{k,{'Page_ST'}})
            out{k} = strcat(out{k},'pp. ',string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),', ');
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Year'}})),'.');
        
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
elseif strcmp(option.format,'utcv')
    tab_org = tab;
    tab = tab_org(tab_org.Language == 'ja',:);
    out = cell(height(tab),1);
    for k = 1:height(tab)
        if option.num % with number?
            out{k} = string(['[',num2str(k),'] ']);
        end
        if strcmp(option.lang,'jp') % output language
            out{k} = strcat(out{k},tab{k,{'Author_JP'}},": ",...
                tab{k,{'Title_JP'}},", ",...
                tab{k,{'Journal_JP'}},", "...
                );
        elseif strcmp(option.lang,'en')
            out{k} = strcat(out{k},tab{k,{'Author_EN'}},": ",...
                tab{k,{'Title_EN'}},", ",...
                tab{k,{'Journal_EN'}},", "...
                );
        else, error('error in option.lang');
        end
        
        if ~isempty(tab{k,{'Vol'}}) && ~isnan(tab{k,{'Vol'}})
            out{k} = strcat(out{k},"Vol. ",string(tab{k,{'Vol'}}),", ");
        end
        
        if ~isempty(tab{k,{'No'}}) && ~isnan(tab{k,{'No'}})
            out{k} = strcat(out{k},'No. ',string(tab{k,{'No'}}),", ");
        end
        
        if ~isempty(tab{k,{'Page_ST'}}) && ~isnan(tab{k,{'Page_ST'}})
            out{k} = strcat(out{k},'pp. ',string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),', ');
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Year'}})),'.');
        
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
    out_jp = out;
    tab = tab_org(tab_org.Language == 'en',:);
    out = cell(height(tab),1);
    for k = 1:height(tab)
        if option.num % with number?
            out{k} = string(['[',num2str(k),'] ']);
        end
        if strcmp(option.lang,'jp') % output language
            out{k} = strcat(out{k},tab{k,{'Author_JP'}},": ",...
                tab{k,{'Title_JP'}},", ",...
                tab{k,{'Journal_JP'}},", "...
                );
        elseif strcmp(option.lang,'en')
            out{k} = strcat(out{k},tab{k,{'Author_EN'}},": ",...
                tab{k,{'Title_EN'}},", ",...
                tab{k,{'Journal_EN'}},", "...
                );
        else, error('error in option.lang');
        end
        
        if ~isempty(tab{k,{'Vol'}}) && ~isnan(tab{k,{'Vol'}})
            out{k} = strcat(out{k},"Vol. ",string(tab{k,{'Vol'}}),", ");
        end
        
        if ~isempty(tab{k,{'No'}}) && ~isnan(tab{k,{'No'}})
            out{k} = strcat(out{k},'No. ',string(tab{k,{'No'}}),", ");
        end
        
        if ~isempty(tab{k,{'Page_ST'}}) && ~isnan(tab{k,{'Page_ST'}})
            out{k} = strcat(out{k},'pp. ',string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),', ');
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Year'}})),'.');
        
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
    out_en = out;
    out = [out_jp;out_en];
    
    
    
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
