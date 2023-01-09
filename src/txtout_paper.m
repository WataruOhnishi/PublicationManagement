function [allpaper,jpaper_out,conf_out,domconf_out,review_out,other_out] = txtout_paper(option)

if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'outOp'), option.outOp = 'all'; end
if ~isfield(option,'paperTitle'), option.paperTitle = true; end
if ~isfield(option,'dateExtract'), option.dateExtract = false; end

%% Journal
jpaper = loadpaper("data/rm_journal_paper.csv");
% print 'all' or 'accepted' or 'submitted'
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
jpaper_out = tab2pub(jpaper,option);

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
conf_out = tab2pub(conf,option);

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
domconf_out = tab2pub(domconf,option);

review = misc(misc.Type == "technical_report"|misc.Type == "introduction_scientific_journal",:);
review_out = tab2pub(review,option);

other = misc(~(misc.Type == "summary_national_conference"|misc.Type == "technical_report"|misc.Type == "introduction_scientific_journal"),:);
other_out = tab2pub(other,option);

%% Fileout
% text
fileID = fopen('paper.txt','w');
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
