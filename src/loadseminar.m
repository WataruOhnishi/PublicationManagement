function seminar = loadseminar(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  INDUSTRIALLECTURE = IMPORTFILE(FILE) reads data from the first
%  worksheet in the Microsoft Excel spreadsheet file named FILE.
%  Returns the data as a table.
%
%  INDUSTRIALLECTURE = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  INDUSTRIALLECTURE = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  industriallecture = importfile("G:\My Drive\Job\Achievement\data\industrial_lecture.xlsx", "conference", [2, 23]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 2023/01/11 23:11:42

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 25];
end

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 18);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":R" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Title_JP", "Title_EN", "Name_JP", "Name_EN", "VarName5", "VarName6", "DateRaw", "Invited", "Language", "ConfType", "VarName11", "Host_JP", "Host_EN", "Place_JP", "Place_EN", "URL", "VarName17", "VarName18"];
opts.VariableTypes = ["string", "string", "categorical", "categorical", "string", "string", "double", "double", "categorical", "double", "double", "string", "string", "string", "string", "string", "string", "string"];

% Specify variable properties
% opts = setvaropts(opts, ["Title_JP", "Title_EN", "Name_JP", "VarName6", "URL", "VarName17", "VarName18"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Title_JP", "Title_EN", "Name_JP", "Name_EN", "VarName5", "VarName6", "Language", "Host_JP", "Host_EN", "Place_JP", "Place_EN", "URL", "VarName17", "VarName18"], "EmptyFieldRule", "auto");

% Import the data
seminar = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":R" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    seminar = [seminar; tb]; %#ok<AGROW>
end

for k = 1:size(seminar,1)
    if strlength(string(seminar.DateRaw(k))) == 4
        seminar.Date(k) = datetime(string(seminar.DateRaw(k)),"InputFormat","yyyy","Locale","ja_JP");
    elseif strlength(string(seminar.DateRaw(k))) == 6
        seminar.Date(k) = datetime(string(seminar.DateRaw(k)),"InputFormat","yyyyMM","Locale","ja_JP");
    elseif strlength(string(seminar.DateRaw(k))) == 8
        seminar.Date(k) = datetime(string(seminar.DateRaw(k)),"InputFormat","yyyyMMdd","Locale","ja_JP");
    else
        error("Error in date format");
    end
end

end



