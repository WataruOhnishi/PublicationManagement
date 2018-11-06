function [prize,prize_out] = txtout_prize(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'Sort'), option.Sort = 'descend'; end
if ~isfield(option,'Num'), option.Num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'Language'), option.Language = 'jp'; end

prize = loadprize('prize.csv');

% sort by date
prize = sortrows(prize,1,option.Sort); % 昇順: ascend, 降順: descend
prize_out = tab2prize(prize,option);

%% Fileout
fileID = fopen('prize.txt','w');
fprintf(fileID,'Award\n');
for k = 1:length(prize_out)
    fprintf(fileID,'%s\n',prize_out{k});
end
fclose(fileID);


