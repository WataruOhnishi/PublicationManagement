function [paper,jpaper_out,conf_out,domconf_out] = txtout_paper(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'outOp'), option.outOp = 'all'; end
if ~isfield(option,'paperTitle'), option.paperTitle = true; end
if ~isfield(option,'dateExtract'), option.dateExtract = false; end


paper = loadpaper('paper.xlsx');
% print 'all' or 'accepted' or 'submitted'
if strcmp(option.outOp,'all')
elseif strcmp(option.outOp,'published')
    paper = paper((paper.Review == '0')|(paper.Review == '1'),:);
elseif strcmp(option.outOp,'accepted')
    paper = paper((paper.Review == '0')|(paper.Review == '1')|(paper.Review == 'accepted'),:);
end

if option.dateExtract
    idx = option.dateFrom <= paper.Year & paper.Year <= option.dateTo;
    paper = paper(idx,:);
end

% sort by date
paper = sortrows(paper,11,option.sort); % 昇順: ascend, 降順: descend

%% Journal
jpaper = paper(paper.Type == 1,:);
jpaper_out = tab2pub(jpaper,option);

%% conference
conf = paper(paper.Type == 2,:);
conf_out = tab2pub(conf,option);

%% domestic conference
domconf = paper(paper.Type == 4,:);
domconf_out = tab2pub(domconf,option);

%% Fileout
% text
fileID = fopen('paper.txt','w');
fprintf(fileID,'Journal paper (with review)\n');
for k = 1:length(jpaper_out)
    fprintf(fileID,'%s\n',jpaper_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('paper.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

% researchmap csv
vnames = textread('paper.csv','%s');
vnames = vnames{1};
paper_rgate = paper((paper.Review == '0')|(paper.Review == '1'),:);
paper_rgate = paper_rgate(:,{paper_rgate.Properties.VariableNames{1:22}});
writetable(paper_rgate,'paper_researchmap.csv');
[~, ~, ~] = movefile('paper_researchmap.csv',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

% kaknen csv
jpaper_kaken = jpaper;
jpaper_kaken = addvars(jpaper_kaken,join([jpaper_kaken.Page_ST,repmat("-",length(jpaper_kaken.Page_ST),1),jpaper_kaken.Page_ED]));
jpaper_kaken = addvars(jpaper_kaken,jpaper_kaken.Year(:).Year);
load('data');
jpaper_kaken = addvars(jpaper_kaken,(contains(jpaper_kaken.Author_JP,international_authors)));
jpaper_kaken = addvars(jpaper_kaken,(contains(jpaper_kaken.Journal_EN,open_access_journal)));
jpaper_kaken = jpaper_kaken(:,[17,3,1,5,7,26,25,12,27,28]);
writetable(jpaper_kaken,'journal_kaken.csv','WriteVariableNames',false,'Encoding','Shift-JIS');
[~, ~, ~] = movefile('journal_kaken.csv',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');
end
