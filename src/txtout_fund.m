function [fundall,fund_out,travel_out] = txtout_fund(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'title'), option.title = 0; end
if ~isfield(option,'amount'), option.amount = 0; end
if ~isfield(option,'date'), option.date = 1; end

fundall = loadfund('competitiveFund.csv');

% sort by date
fundall = sortrows(fundall,7,option.sort); % 昇順: ascend, 降順: descend

%% fund
fund = fundall(fundall.Type == '1',:);
fund_out = tab2fund(fund,option);

%% travel
travel = fundall(fundall.Type == '2',:);
option.format = 'travel'; % 
travel_out = tab2fund(travel,option);

%% Fileout
fileID = fopen('competitiveFund.txt','w');
fprintf(fileID,'Fund\n');
for k = 1:length(fund_out)
    fprintf(fileID,'%s\n',fund_out{k});
end
fprintf(fileID,'\nTravel\n');
for k = 1:length(travel_out)
    fprintf(fileID,'%s\n',travel_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('competitiveFund.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

