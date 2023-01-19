function [allpaper,jpaper_out,conf_out,domconf_out,review_out,other_out] = txtout_paper(option)

if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jpn'; end
if ~isfield(option,'outOp'), option.outOp = 'all'; end
if ~isfield(option,'paperTitle'), option.paperTitle = true; end
if ~isfield(option,'dateExtract'), option.dateExtract = false; end

%% Journal
jpaper = loadpaper("data/rm_journal_paper.csv");
if strcmp(option.outOp,'all')
elseif strcmp(option.outOp,'published')
    jpaper = jpaper(jpaper.Public == 'disclosed',:);
end

if option.dateExtract
    idx = option.dateFrom <= jpaper.Date & jpaper.Date <= option.dateTo;
    jpaper = jpaper(idx,:);
end

% sort by date
jpaper = sortrows(jpaper,34,option.sort); % 昇順: ascend, 降順: descend
jpaper = jpaper(jpaper.Type == "scientific_journal",:);

%% conference
conf = loadpaper("data/rm_international_conference_papers.csv");
% print 'all' or 'accepted' or 'submitted'
if strcmp(option.outOp,'all')
elseif strcmp(option.outOp,'published')
    conf = conf(conf.Public == 'disclosed',:);
end

if option.dateExtract
    idx = option.dateFrom <= conf.Date & conf.Date <= option.dateTo;
    conf = conf(idx,:);
end

% sort by date
conf = sortrows(conf,34,option.sort); % 昇順: ascend, 降順: descend
conf = conf(conf.Type == "international_conference_proceedings",:);

%% misc
misc = loadpaper("data/rm_misc.csv");
% print 'all' or 'accepted' or 'submitted'
if strcmp(option.outOp,'all')
elseif strcmp(option.outOp,'published')
    misc = misc(misc.Public == 'disclosed',:);
end

if option.dateExtract
    idx = option.dateFrom <= misc.Date & misc.Date <= option.dateTo;
    misc = misc(idx,:);
end

% sort by date
misc = sortrows(misc,34,option.sort); % 昇順: ascend, 降順: descend

% extract
domconf = misc(misc.Type == "summary_national_conference",:);

review = misc(misc.Type == "technical_report"|misc.Type == "introduction_scientific_journal",:);

other = misc(~(misc.Type == "summary_national_conference"|misc.Type == "technical_report"|misc.Type == "introduction_scientific_journal"),:);

%% Fileout
if strcmp(option.format,'md')
    % Japanese
    option.lang = 'jpn';
    option.outOp = 'published';
    option.inJP = false;
    option.num = false;
    
    jpaper_out = tab2pub(jpaper,option);
    conf_out = tab2pub(conf,option);
    domconf_out = tab2pub(domconf,option);
    review_out = tab2pub(review,option);
    other_out = tab2pub(other,option);
    
    fileID = fopen('publications.md','w');
    fprintf(fileID,'## 査読付き論文誌論文\n');
    for k = 1:length(jpaper_out)
        fprintf(fileID,'%s\n',jpaper_out{k});
    end
    fprintf(fileID,'\n## 査読付き国際会議プロシーディングス\n');
    for k = 1:length(conf_out)
        fprintf(fileID,'%s\n',conf_out{k});
    end
    fprintf(fileID,'\n## 査読なし研究会・大会\n');
    for k = 1:length(domconf_out)
        fprintf(fileID,'%s\n',domconf_out{k});
    end
    fprintf(fileID,'\n## 解説論文\n');
    for k = 1:length(review_out)
        fprintf(fileID,'%s\n',review_out{k});
    end
    if ~isempty(other_out)
        fprintf(fileID,'\n## その他\n');
        for k = 1:length(other_out)
            fprintf(fileID,'%s\n',other_out{k});
        end
    end
    
    % English
    option.lang = 'eng';
    option.outOp = 'published';
    option.inJP = true;
    
    jpaper_out = tab2pub(jpaper,option);
    conf_out = tab2pub(conf,option);
    domconf_out = tab2pub(domconf,option);
    review_out = tab2pub(review,option);
    other_out = tab2pub(other,option);
    
    clear fileID
    fileID = fopen('publications_en.md','w');
    fprintf(fileID,'## Journal Articles (peer-reviewed)\n');
    for k = 1:length(jpaper_out)
        fprintf(fileID,'%s\n',jpaper_out{k});
    end
    fprintf(fileID,'\n## International Conference Publications (peer-reviewed)\n');
    for k = 1:length(conf_out)
        fprintf(fileID,'%s\n',conf_out{k});
    end
    fprintf(fileID,'\n## Domestic Conference Publications (non peer-reviewed)\n');
    for k = 1:length(domconf_out)
        fprintf(fileID,'%s\n',domconf_out{k});
    end
    fprintf(fileID,'\n## Review paper\n');
    for k = 1:length(review_out)
        fprintf(fileID,'%s\n',review_out{k});
    end
    
    if ~isempty(other_out)
        fprintf(fileID,'\n## Other\n');
        for k = 1:length(other_out)
            fprintf(fileID,'%s\n',other_out{k});
        end
    end
    
    [~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
    [~, ~, ~] = movefile('publications.md',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');
    [~, ~, ~] = movefile('publications_en.md',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');
else
    jpaper_out = tab2pub(jpaper,option);
    conf_out = tab2pub(conf,option);
    domconf_out = tab2pub(domconf,option);
    review_out = tab2pub(review,option);
    other_out = tab2pub(other,option);
    
    fileID = fopen('publications.txt','w');
    fprintf(fileID,'Journal paper (with review)\n');
    for k = 1:length(jpaper_out)
        fprintf(fileID,'%s\n',jpaper_out{k});
    end
    fprintf(fileID,'\nConference paper (with review)\n');
    for k = 1:length(conf_out)
        fprintf(fileID,'%s\n',conf_out{k});
    end
    fprintf(fileID,'\nDomestic conference paper (without review)\n');
    for k = 1:length(domconf_out)
        fprintf(fileID,'%s\n',domconf_out{k});
    end
    fprintf(fileID,'\nReview paper\n');
    for k = 1:length(review_out)
        fprintf(fileID,'%s\n',review_out{k});
    end
    fprintf(fileID,'\nOthers\n');
    for k = 1:length(other_out)
        fprintf(fileID,'%s\n',other_out{k});
    end
    
    fclose(fileID);
    
    [~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
    [~, ~, ~] = movefile('publications.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');
end

allpaper = [jpaper;conf;domconf;review;other];
end



% % kaknen csv
% jpaper_kaken = jpaper;
% jpaper_kaken = addvars(jpaper_kaken,join([jpaper_kaken.Page_ST,repmat("-",length(jpaper_kaken.Page_ST),1),jpaper_kaken.Page_ED]));
% jpaper_kaken = addvars(jpaper_kaken,jpaper_kaken.Year(:).Year);
% load('data');
% jpaper_kaken = addvars(jpaper_kaken,(contains(jpaper_kaken.Author_JP,international_authors)));
% jpaper_kaken = addvars(jpaper_kaken,(contains(jpaper_kaken.Journal_EN,open_access_journal)));
% jpaper_kaken = jpaper_kaken(:,[17,3,1,5,7,26,25,12,27,28]);
% writetable(jpaper_kaken,'journal_kaken.csv','WriteVariableNames',false,'Encoding','Shift-JIS');
% [~, ~, ~] = movefile('journal_kaken.csv',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');
