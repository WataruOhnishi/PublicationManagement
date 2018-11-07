function [fundall,fund_out,travel_out] = txtout_fund(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'Sort'), option.Sort = 'descend'; end
if ~isfield(option,'Num'), option.Num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'Language'), option.Language = 'jp'; end
if ~isfield(option,'title'), option.title = 0; end
if ~isfield(option,'amount'), option.amount = 0; end
if ~isfield(option,'date'), option.date = 1; end

fundall = loadfund('competitiveFund.csv');

% sort by date
fundall = sortrows(fundall,7,option.Sort); % 昇順: ascend, 降順: descend

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


