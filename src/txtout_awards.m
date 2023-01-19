function [awards,awards_out] = txtout_awards(option)

if ~isfield(option,'filename'), option.filename = 'data/rm_awards.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end

awards = loadawards(option.filename);

% sort by date
awards = sortrows(awards,21,option.sort); % 昇順: ascend, 降順: descend
awards_out = tab2awards(awards,option);

%% Fileout
if strcmp(option.format,'md'), fname = 'awards.md'; else, fname = 'awards.txt'; end
fileID = fopen(fname,'w');
fprintf(fileID,'# 受賞歴\n');
for k = 1:length(awards_out)
    fprintf(fileID,'%s\n',awards_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile(fname,['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

