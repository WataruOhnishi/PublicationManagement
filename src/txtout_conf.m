function [conf,conf_out] = txtout_conf(option)

if ~isfield(option,'filename'), option.filename = 'conference.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end

conf = loadconf('conference.csv');

% sort by date
conf = sortrows(conf,7,option.sort); % 昇順: ascend, 降順: descend
conf_out = tab2conf(conf,option);

%% Fileout
fileID = fopen('conference.txt','w');
fprintf(fileID,'Invited talk, lectures\n');
for k = 1:length(conf_out)
    fprintf(fileID,'%s\n',conf_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('conference.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

