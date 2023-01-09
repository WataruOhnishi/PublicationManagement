function [fundall,fundall_out] = txtout_fund(option)

if ~isfield(option,'filename'), option.filename = 'data/rm_research_projects'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'title'), option.title = 0; end
if ~isfield(option,'amount'), option.amount = 0; end
if ~isfield(option,'date'), option.date = 1; end

fundall = loadfund(option.filename);

% sort by date
fundall = sortrows(fundall,17,option.sort); % 昇順: ascend, 降順: descend
fundall_out = tab2fund(fundall,option);

%% Fileout
fileID = fopen('competitiveFund.txt','w');
fprintf(fileID,'Fund\n');
for k = 1:length(fundall_out)
    fprintf(fileID,'%s\n',fundall_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('competitiveFund.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

end