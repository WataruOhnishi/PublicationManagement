function papercount(tab,showflag)
if nargin < 2, showflag = false; end

ja = tab(logical((tab.Language == 'ja')+(tab.Language == 'jp')),:);
% do not count technical meeting
ja = ja(~(ja.Type == 5),:);
ja_recent = ja(isrecent(ja),:);

fprintf('\nJapanese article count\n');
fprintf('Single author\n');
fprintf('%d(%d)\n',sum(istancho(ja)),sum(istancho(ja_recent)));
if showflag
    ja(istancho(ja),:) 
end
fprintf('Co-author (first)\n');
fprintf('%d(%d)\n',sum(~istancho(ja).*ishittou(ja)),sum(~istancho(ja_recent).*ishittou(ja_recent)));
if showflag
    ja(logical(~istancho(ja).*ishittou(ja)),:)
end
fprintf('Co-author (non-first)\n');
fprintf('%d(%d)\n',sum(~istancho(ja).*~ishittou(ja)),sum(~istancho(ja_recent).*~ishittou(ja_recent)));
if showflag
    ja(logical(~istancho(ja).*~ishittou(ja)),:) 
end

en = tab(tab.Language == 'en',:);
en = en(~(en.Type == 5),:);
en_recent = en(isrecent(en),:);

fprintf('English article count\n');
fprintf('Single author\n');
if showflag
    en(istancho(en),:) 
end
fprintf('%d(%d)\n',sum(istancho(en)),sum(istancho(en_recent)));
fprintf('Co-author (first)\n');
fprintf('%d(%d)\n',sum(~istancho(en).*ishittou(en)),sum(~istancho(en_recent).*ishittou(en_recent)));
if showflag
    en(logical(~istancho(en).*ishittou(en)),:)
end
fprintf('Co-author (non-first)\n');
fprintf('%d(%d)\n',sum(~istancho(en).*~ishittou(en)),sum(~istancho(en_recent).*~ishittou(en_recent)));
if showflag
    en(logical(~istancho(en).*~ishittou(en)),:) 
end
fprintf('Todal %d\n',height(ja)+height(en));

end

function flag = istancho(tab)
flag = nan(height(tab),1);
    for k = 1:height(tab)
        authorlist = strsplit(tab.Author_EN(k),', ');
        if length(authorlist) == 1 && any(lower(authorlist) == lower("Wataru Ohnishi"))
            flag(k) = true;
        else
            flag(k) = false;
        end
    end
    flag = logical(flag);
end

function flag = ishittou(tab)
flag = nan(height(tab),1);
    for k = 1:height(tab)
        authorlist = strsplit(tab.Author_EN(k),', ');
        if lower(authorlist(1)) == lower("Wataru Ohnishi")
            flag(k) = true;
        else
            flag(k) = false;
        end
    end
    flag = logical(flag);
end

function flag = isrecent(tab)
d = datetime(now,'ConvertFrom','datenum');
y = d.Year;

flag = tab.Year >= datetime(d.Year - 5,1,1);
end

