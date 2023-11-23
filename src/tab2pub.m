function out = tab2pub(tab,option)
N = size(tab,1); % number of paper
out = cell(N,1);
if strcmp(option.format,'standard')||strcmp(option.format,'md')
    for k = 1:N
        if option.num
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
            if tab{k,'Language'} == 'jp'
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
elseif strcmp(option.format,'utcv')
    tab_org = tab;
    tab = tab_org(tab_org.Language == 'jp',:);
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
            if tab{k,'Language'} == 'jp'
                out{k} = join([out{k},' (in Japanese)'],'');
            end
        end
    end
    out_en = out;
    out = [out_jp;out_en];

else
    error('error on option.format');
end

if strcmp(option.format,'md')
    if exist("data/list_openAccess.csv")
        oapaper = loadpaper("data/list_openAccess.csv");
        flag_oa = true;
    else 
        flag_oa = false;
    end
    for k = 1:length(out)
        if strlength(tab.DOI(k)) > 0
            out{k} = "["+out{k}+"]("+"https://doi.org/"+tab.DOI(k)+")";
        elseif strlength(tab.URL(k))
            out{k} = "["+out{k}+"]("+tab.URL(k)+")";
        end
        out{k} = "1. "+out{k};
        if strlength(tab.URL2(k)) > 0
           out{k} = out{k}+" [[preprint]("+tab.URL2(k)+")]";
        end
        if flag_oa
            if ismember(tab.DOI(k),oapaper.DOI)
                out{k} = out{k} + " [[open access]("+"https://doi.org/"+tab.DOI(k)+")]";
            end
        end
    end
end

end
