function [allpaper,jpaper_out,conf_out,domconf_out,review_out,other_out] = txtout_paper(option)
%TXTOUT_PAPER  Read Researchmap CSVs and write a publication list.
%   Supported option.format:
%     'standard' : publications.txt
%     'md'       : publications.md / publications_en.md (Jekyll)
%     'kaken'    : journal/conf/domconf CSVs for KAKEN
%   All outputs are moved to ./publications/yyyymmdd/.

%% Option defaults
if ~isfield(option,'sort'),        option.sort = 'descend'; end
if ~isfield(option,'num'),         option.num = false; end
if ~isfield(option,'inJP'),        option.inJP = false; end
if ~isfield(option,'lang'),        option.lang = 'jpn'; end
if ~isfield(option,'outOp'),       option.outOp = 'all'; end
if ~isfield(option,'paperTitle'),  option.paperTitle = true; end
if ~isfield(option,'dateExtract'), option.dateExtract = false; end
if ~isfield(option,'format'),      option.format = 'standard'; end

%% Load & categorize
% Journal
jpaper = prepPaper(loadpaper("data/rm_journal_paper.csv"), option);
jpaper = jpaper(jpaper.Type == "scientific_journal",:);

% International conference
conf = prepPaper(loadpaper("data/rm_international_conference_papers.csv"), option);
conf = conf(conf.Type == "international_conference_proceedings",:);

% Misc -> domestic conference / review / other
misc = prepPaper(loadpaper_xlsx("data/rm_misc.xlsx"), option);
isDomconf = misc.Type == "summary_national_conference";
isReview  = misc.Type == "technical_report" | misc.Type == "introduction_scientific_journal";
domconf = misc(isDomconf,:);
review  = misc(isReview,:);
other   = misc(~(isDomconf | isReview),:);

%% File output
switch option.format
    case 'md'
        % Japanese
        optJp = option;
        optJp.lang = 'jpn'; optJp.outOp = 'published';
        optJp.inJP = false; optJp.num = false;
        [jp,cf,dc,rv,ot] = makeOutputs(jpaper,conf,domconf,review,other,optJp);
        headersJp = {'## 査読付き論文誌論文', ...
                     '## 査読付き国際会議プロシーディングス', ...
                     '## 査読なし研究会・大会', ...
                     '## 解説論文', ...
                     '## その他'};
        writeMdFile('publications.md', headersJp, {jp,cf,dc,rv,ot});

        % English (return values are the English outputs, as before)
        optEn = optJp;
        optEn.lang = 'eng'; optEn.inJP = true;
        [jpaper_out,conf_out,domconf_out,review_out,other_out] = ...
            makeOutputs(jpaper,conf,domconf,review,other,optEn);
        headersEn = {'## Journal Articles (peer-reviewed)', ...
                     '## International Conference Publications (peer-reviewed)', ...
                     '## Domestic Conference Publications (non peer-reviewed)', ...
                     '## Review paper', ...
                     '## Other'};
        writeMdFile('publications_en.md', headersEn, ...
            {jpaper_out,conf_out,domconf_out,review_out,other_out});

        moveToDatedDir({'publications.md','publications_en.md'});

    case 'kaken'
        % Return values are the standard-format outputs.
        optStd = option; optStd.format = 'standard';
        [jpaper_out,conf_out,domconf_out,review_out,other_out] = ...
            makeOutputs(jpaper,conf,domconf,review,other,optStd);

        writeJournalKaken(jpaper, "journal_kaken.csv");
        writeConfKaken(conf,    ["Author_EN","Title_EN","Journal_EN"], "conf_kaken.csv");
        writeConfKaken(domconf, ["Author_JP","Title_JP","Journal_JP"], "domconf_kaken.csv");

        moveToDatedDir({'journal_kaken.csv','conf_kaken.csv','domconf_kaken.csv'});

    otherwise % 'standard'
        [jpaper_out,conf_out,domconf_out,review_out,other_out] = ...
            makeOutputs(jpaper,conf,domconf,review,other,option);
        headers = {'Journal paper (with review)', ...
                   'Conference paper (with review)', ...
                   'Domestic conference paper (without review)', ...
                   'Review paper', ...
                   'Others'};
        writeTxtFile('publications.txt', headers, ...
            {jpaper_out,conf_out,domconf_out,review_out,other_out});

        moveToDatedDir({'publications.txt'});
end

allpaper = [jpaper;conf;domconf;review;other];
end

%% ===== helpers =====

function tbl = prepPaper(tbl, option)
% Filter by disclosure/date and sort by Date (column 34, added by loadpaper).
if strcmp(option.outOp,'published')
    tbl = tbl(tbl.Public == 'disclosed',:);
end
if option.dateExtract
    idx = option.dateFrom <= tbl.Date & tbl.Date <= option.dateTo;
    tbl = tbl(idx,:);
end
tbl = sortrows(tbl,34,option.sort); % ascend / descend
end

function varargout = makeOutputs(jpaper,conf,domconf,review,other,option)
% Format each category through tab2pub.
tabs = {jpaper,conf,domconf,review,other};
varargout = cellfun(@(t) tab2pub(t,option), tabs, 'UniformOutput', false);
end

function writeTxtFile(filename, headers, outs)
% Plain text: every section is written, blank line before each but the first.
fileID = fopen(filename,'w');
for s = 1:numel(headers)
    if s == 1
        fprintf(fileID,'%s\n',headers{s});
    else
        fprintf(fileID,'\n%s\n',headers{s});
    end
    writeLines(fileID, outs{s});
end
fclose(fileID);
end

function writeMdFile(filename, headers, outs)
% Markdown (Jekyll): reversed-list marker between sections; the last "Other"
% section is omitted when empty.
nSec = numel(headers);
if isempty(outs{end})
    nSec = nSec - 1;
end
fileID = fopen(filename,'w');
for s = 1:nSec
    if s == 1
        fprintf(fileID,'%s\n',headers{s});
    else
        fprintf(fileID,'{: reversed="reversed"}\n\n');
        fprintf(fileID,'\n%s\n',headers{s});
    end
    writeLines(fileID, outs{s});
end
fclose(fileID);
end

function writeLines(fileID, lines)
for k = 1:numel(lines)
    fprintf(fileID,'%s\n',lines{k});
end
end

function moveToDatedDir(files)
outDir = fullfile('publications', datestr(datetime('now'),'yyyymmdd'));
[~,~,~] = mkdir(outDir);
for i = 1:numel(files)
    [~,~,~] = movefile(files{i}, outDir, 'f');
end
end

function writeJournalKaken(jpaper, filename)
t = jpaper;
t.Year = year(t.Date);
for k = 1:height(t)
    if isnan(t.Page_ST)
        t.Page(k) = nan;
    else
        t.Page(k) = string(t.Page_ST(k)) + " - " + string(t.Page_ED(k));
    end
    t.OpenAccess(k) = strcmp(t.Journal_JP(k),"IEEJ Journal of Industry Applications");
end
t.Review = double(t.Review=="TRUE");
t.International_Work = double(t.International_Work=="TRUE");
t = t(:,["DOI","Author_JP","Title_JP","Journal_JP","Vol","Year","Page", ...
         "Review","International_Work","OpenAccess"]);
writetable(t,filename,"Encoding","Shift-JIS",'WriteVariableNames',false);
end

function writeConfKaken(conf, cols, filename)
% cols = [Author, Title, Journal] variable names (EN for intl, JP for domestic).
t = conf;
t.Year = year(t.Date);
t.Invited = double(t.Invited=="TRUE");
t.VarName25 = double(t.VarName25=="TRUE");
t = t(:,[cols(1),cols(2),cols(3),"Year","Year","Invited","VarName25"]);
writetable(t,filename,"Encoding","Shift-JIS",'WriteVariableNames',false);
end
