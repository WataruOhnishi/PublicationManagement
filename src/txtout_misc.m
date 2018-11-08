function [misc,review_out,other_out] = txtout_misc(option)

if ~isfield(option,'filename'), option.filename = 'paper.csv'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'inJP'), option.inJP = false; end
if ~isfield(option,'lang'), option.lang = 'jp'; end
if ~isfield(option,'OutOptions'), option.OutOptions = 'all'; end

misc = loadpaper('misc.csv');
% print 'all' or 'accepted' or 'submitted'
if strcmp(option.OutOptions,'all')
elseif strcmp(option.OutOptions,'published')
    misc = misc((misc.Review == '0')|(misc.Review == '1'),:);
elseif strcmp(option.OutOptions,'accepted')
    misc = misc((misc.Review == '0')|(misc.Review == '1')|(misc.Review == 'accepted'),:);
end

% sort by date
misc = sortrows(misc,11,option.sort); % 昇順: ascend, 降順: descend


%% Review
review = misc(misc.Type == '7',:);
review_out = tab2pub(review,option);

%% misc
other = misc(misc.Type == '11',:);
other_out = tab2pub(other,option);

%% Fileout
fileID = fopen('misc.txt','w');
fprintf(fileID,'Review paper\n');
for k = 1:length(review_out)
    fprintf(fileID,'%s\n',review_out{k});
end
fprintf(fileID,'\nOthers\n');
for k = 1:length(other_out)
    fprintf(fileID,'%s\n',other_out{k});
end
fclose(fileID);


