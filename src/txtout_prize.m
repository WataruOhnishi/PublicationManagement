function [prize,prize_out] = txtout_prize(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'name'), option.name = 0; end
if ~isfield(option,'lang'), option.lang = 'jp'; end

prize = loadprize('prize.csv');

% sort by date
prize = sortrows(prize,1,option.sort); % 昇順: ascend, 降順: descend
prize_out = tab2prize(prize,option);

%% Fileout
fileID = fopen('prize.txt','w');
fprintf(fileID,'Award\n');
for k = 1:length(prize_out)
    fprintf(fileID,'%s\n',prize_out{k});
end
fclose(fileID);


