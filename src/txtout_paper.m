function [paper,jpaper_out,conf_out,domconf_out] = txtout_paper(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'outOp'), option.outOp = 'all'; end

paper = loadpaper('paper.csv');
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
jpaper = paper(paper.Type == '1',:);
jpaper_out = tab2pub(jpaper,option);

%% conference
conf = paper(paper.Type == '2',:);
conf_out = tab2pub(conf,option);

%% domestic conference
domconf = paper(paper.Type == '4',:);
domconf_out = tab2pub(domconf,option);

%% Fileout
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
fclose(fileID);


