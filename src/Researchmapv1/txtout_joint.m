function [joint,joint_out] = txtout_joint(option)

if ~isfield(option,'filename'), option.filename = 'jointResearch.xlsx'; end
if ~isfield(option,'sort'), option.sort = 'descend'; end
if ~isfield(option,'num'), option.num = false; end
if ~isfield(option,'title'), option.title = 0; end
if ~isfield(option,'date'), option.date = false; end

joint = loadjoint('jointResearch.xlsx');

% sort by date
company = joint(contains(joint.Company,"会社"),:);
company = sortrows(company,4,option.sort); % 昇順: ascend, 降順: descend
company = sortrows(company,1,'ascend'); % 昇順: ascend, 降順: descend

univ = joint(~contains(joint.Company,"会社"),:);
univ = sortrows(univ,4,option.sort); % 昇順: ascend, 降順: descend
univ = sortrows(univ,1,option.sort); % 昇順: ascend, 降順: descend

N = height(company)+height(univ);
joint_out = cell(N,1);
for k = 1:height(company)
   if option.num
       joint_out{k} = string(['[',num2str(k),'] ']);
   end
   joint_out{k} = strcat(joint_out{k},company.Company(k),", ",company.Title(k), ", ",...
       datestr(company.StartDate(k),'yyyy/mm/dd'),"-",datestr(company.EndDate(k),'yyyy/mm/dd'),", ",...
       string(num2str(round(company.Amont_total(k)/1e4))),"万円. ");
end

for k = 1:height(univ)
   if option.num
       joint_out{k+height(company)} = string(['[',num2str(k+height(company)),'] ']);
   end
   joint_out{k+height(company)} = strcat(joint_out{k+height(company)},univ.Company(k),", ",univ.Title(k), ", ",...
       datestr(univ.StartDate(k),'yyyy/mm/dd'),"-",datestr(univ.EndDate(k),'yyyy/mm/dd'),", ",...
       string(num2str(round(univ.Amont_total(k)/1e4))),"万円. ");
end


%% Fileout
fileID = fopen('jointResearch.txt','w');
% fprintf(fileID,'Invited talk, lectures\n');
for k = 1:length(joint_out)
    fprintf(fileID,'%s\n',joint_out{k});
end
fclose(fileID);

[~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
[~, ~, ~] = movefile('jointResearch.txt',['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');

