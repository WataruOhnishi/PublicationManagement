function [seminar,seminar_out] = txtout_seminar(option)

if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end

seminar = loadseminar('data/seminar.xlsx');

% sort by date
seminar = sortrows(seminar,7,option.sort); % 昇順: ascend, 降順: descend
seminar_out = tab2seminar(seminar,option);

%% Fileout
fileID = fopen('seminar.txt','w');
fprintf(fileID,'# セミナー\n');
for k = 1:length(seminar_out)
    fprintf(fileID,'%s\n',seminar_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('seminar.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

