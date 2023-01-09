function out = tab2pub(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')
    for k = 1:N
        if option.num % with number?
            out{k} = string(['[',num2str(k),'] ']);
        end
        if strcmp(option.lang,'jpn') % output language
            out{k} = strcat(out{k},tab{k,{'Author_JP'}},": ",...
                tab{k,{'Title_JP'}},", ",...
                tab{k,{'Journal_JP'}},", "...
                );
        elseif strcmp(option.lang,'eng')
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
            out{k} = strcat(out{k},"pp. ",string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),", ");
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Date'}})),'.');
        
        if tab{k,'Review'} == 'accepted' % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif tab{k,'Review'} == 'submitted'
            out{k} = join([out{k},' (submitted)'],'');
        end
        
        if option.inJP
            if tab{k,'Language'} == 'jpn'
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
elseif strcmp(option.format,'utcv')
    tab_org = tab;
    tab = tab_org(tab_org.Language == 'jpn',:);
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
        elseif strcmp(option.lang,'eng')
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
            out{k} = strcat(out{k},"No. ",string(tab{k,{'No'}}),", ");
        end
        
        if ~isempty(tab{k,{'Page_ST'}}) && ~isnan(tab{k,{'Page_ST'}})
            out{k} = strcat(out{k},"pp. ",string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),", ");
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Date'}})),'.');
        
        if num2str(tab{k,'Review'}) == "accepted" % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif num2str(tab{k,'Review'}) == "submitted"
            out{k} = join([out{k},' (submitted)'],'');
        end
        
        if option.inJP
            if tab{k,'Language'} == "jpn"
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
    out_jp = out;
    tab = tab_org(tab_org.Language == 'eng',:);
    out = cell(height(tab),1);
    for k = 1:height(tab)
        if option.num % with number?
            out{k} = string(['[',num2str(k),'] ']);
        end
        if strcmp(option.lang,'jpn') % output language
            out{k} = strcat(out{k},tab{k,{'Author_JP'}},": ",...
                tab{k,{'Title_JP'}},", ",...
                tab{k,{'Journal_JP'}},", "...
                );
        elseif strcmp(option.lang,'eng')
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
            out{k} = strcat(out{k},"No. ",string(tab{k,{'No'}}),", ");
        end
        
        if ~isempty(tab{k,{'Page_ST'}}) && ~isnan(tab{k,{'Page_ST'}})
            out{k} = strcat(out{k},"pp. ",string(tab{k,{'Page_ST'}}),...
                '-',string(tab{k,{'Page_ED'}}),", ");
        end
        
        out{k} = strcat(out{k},string(year(tab{k,{'Year'}})),'.');
        
        if tab{k,'Review'} == 'accepted' % accepted or submitted
            out{k} = join([out{k},' (accepted)'],'');
        elseif tab{k,'Review'} == 'submitted'
            out{k} = join([out{k},' (submitted)'],'');
        end
        
        if option.inJP
            if tab{k,'Language'} == 'jpn'
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
    out_en = out;
    out = [out_jp;out_en];

else
    error('error on option.format');
end

end
