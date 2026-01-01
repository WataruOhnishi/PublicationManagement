function paper = loadpaper_xlsx(filename, dataLines, sheet)
%LOADPAPER_XLSX Import data from an Excel file (.xlsx)
%  PAPER = LOADPAPER_XLSX(FILENAME) reads data from an Excel file and
%  returns the data as a table.
%
%  PAPER = LOADPAPER_XLSX(FILENAME, DATALINES) reads data for the specified
%  row interval(s). Specify DATALINES as a positive scalar integer or a
%  N-by-2 array of positive scalar integers for dis-contiguous row intervals.
%
%  PAPER = LOADPAPER_XLSX(FILENAME, DATALINES, SHEET) reads from the given sheet.
%
%  Example:
%    paper = loadpaper_xlsx("rm_misc.xlsx", [3 Inf], 1);

%% Input handling
if nargin < 2 || isempty(dataLines)
    dataLines = [3, Inf];
end
if nargin < 3 || isempty(sheet)
    sheet = 1;  % sheet index or sheet name
end

%% Set up Import Options for Excel
opts = spreadsheetImportOptions("NumVariables", 33);
opts.Sheet = sheet;

% Specify column names and types (same as your CSV version)
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "ID", "Title_JP", "Title_EN", ...
    "Author_JP", "Author_EN", "Role", "VarName10", "VarName11", "VarName12", "VarName13", ...
    "DateRaw", "Journal_JP", "Journal_EN", "Vol", "No", "Page_ST", "Page_ED", ...
    "Language", "Review", "Invited", "Type", "VarName25", "International_Work", ...
    "DOI", "ISSN", "eISSN", "URL", "URL2", "VarName32", "Public"];

opts.VariableTypes = ["categorical", "categorical", "categorical", "string", "string", "string", ...
    "string", "string", "categorical", "string", "string", "string", "string", ...
    "double", "string", "string", "double", "double", "double", "double", ...
    "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", ...
    "string", "string", "string", "string", "string", "categorical", "categorical"];

% Variable options (whitespace / empty)
opts = setvaropts(opts, ["ID", "Title_JP", "Title_EN", "Author_JP", "Author_EN", ...
    "VarName10", "VarName11", "DOI", "ISSN", "eISSN", "URL"], "WhitespaceRule", "preserve");

opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "ID", "Title_JP", "Title_EN", ...
    "Author_JP", "Author_EN", "Role", "VarName10", "VarName11", "VarName12", "VarName13", ...
    "Journal_JP", "Journal_EN", "Language", "Review", "Invited", "Type", "VarName25", ...
    "International_Work", "DOI", "ISSN", "eISSN", "URL", "VarName32", "Public"], ...
    "EmptyFieldRule", "auto");

%% Read (handle dataLines -> Excel range)
% If endRow is Inf, use start-cell form ("A3") which is accepted robustly across versions.
lastCol = localExcelCol(33);   % "AG"

if size(dataLines,1) == 1
    startRow = dataLines(1,1);
    endRow   = dataLines(1,2);

    if isinf(endRow)
        % Start-cell only (read until the end of used range)
        opts.DataRange = char(sprintf("A%d", startRow));
    else
        % Rectangle
        opts.DataRange = char(sprintf("A%d:%s%d", startRow, lastCol, endRow));
    end

    paper = readtable(filename, opts);

else
    % Dis-contiguous intervals: read each interval and concatenate
    paper = table();
    for i = 1:size(dataLines,1)
        startRow = dataLines(i,1);
        endRow   = dataLines(i,2);

        opts_i = opts;

        if isinf(endRow)
            opts_i.DataRange = char(sprintf("A%d", startRow));
        else
            opts_i.DataRange = char(sprintf("A%d:%s%d", startRow, lastCol, endRow));
        end

        tmp = readtable(filename, opts_i);

        % If finite interval, keep only the requested number of rows (safety)
        if ~isinf(endRow)
            nKeep = endRow - startRow + 1;
            if height(tmp) > nKeep
                tmp = tmp(1:nKeep,:);
            end
        end

        paper = [paper; tmp]; %#ok<AGROW>
    end
end

%% shape dates (same as original; DateRaw is assumed numeric like yyyy / yyyyMM / yyyyMMdd)
paper.Date = NaT(size(paper,1),1);

for k = 1:size(paper,1)
    s = string(paper.DateRaw(k));
    if strlength(s) == 4
        paper.Date(k) = datetime(s, "InputFormat","yyyy", "Locale","ja_JP");
    elseif strlength(s) == 6
        paper.Date(k) = datetime(s, "InputFormat","yyyyMM", "Locale","ja_JP");
    elseif strlength(s) == 8
        paper.Date(k) = datetime(s, "InputFormat","yyyyMMdd", "Locale","ja_JP");
    else
        error("Error in date format");
    end
end

paper.Author_JP = strrep(strrep(paper.Author_JP,"[",""),"]","");
paper.Author_EN = strrep(strrep(paper.Author_EN,"[",""),"]","");

end

%% Local function: column number -> Excel letters (1->A, 26->Z, 27->AA, ...)
function letters = localExcelCol(n)
letters = "";
while n > 0
    r = mod(n-1, 26);
    letters = string(char("A" + r)) + letters;
    n = floor((n-1)/26);
end
letters = char(letters);
end
