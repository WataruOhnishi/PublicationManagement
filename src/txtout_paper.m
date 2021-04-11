function [paper,jpaper_out,conf_out,domconf_out] = txtout_paper(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'outOp'), option.outOp = 'all'; end

paper = loadpaper('paper.xlsx');
% print 'all' or 'accepted' or 'submitted'
if strcmp(option.outOp,'all')
elseif strcmp(option.outOp,'published')
    paper = paper((paper.Review == '0')|(paper.Review == '1'),:);
elseif strcmp(option.outOp,'accepted')
    paper = paper((paper.Review == '0')|(paper.Review == '1')|(paper.Review == 'accepted'),:);
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

% paperresearchmap = importfile('paper_researchmap.csv');
% % paperresearchmap = [vnames(1:22);paperresearchmap;];
% fileID = fopen('paper_researchmap.csv','w');
% % formatSpec = '%s %d %2.1f %s\n';
% [nrows,ncols] = size(paperresearchmap);
% fprintf(fileID,'%s\n',vnames(1:171));
% for row = 2:nrows
%     fprintf(fileID,'%s\n',paperresearchmap{row,:});
% end
% fclose(fileID);

end
