function paper1 = importfile(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  PAPER1 = IMPORTFILE(FILE) reads data from the first worksheet in the
%  Microsoft Excel spreadsheet file named FILE.  Returns the data as a
%  table.
%
%  PAPER1 = IMPORTFILE(FILE, SHEET) reads from the specified worksheet.
%
%  PAPER1 = IMPORTFILE(FILE, SHEET, DATALINES) reads from the specified
%  worksheet for the specified row interval(s). Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  paper1 = importfile("paper.xlsx", "paper", [2, 14]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 11-Apr-2021 13:48:22

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 10000];
end

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 24);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":X" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Title_JP", "Title_EN", "Author_JP", "Author_EN", "Journal_JP", "Journal_EN", "Vol", "No", "Page_ST", "Page_ED", "Year", "Review", "Invited", "Language", "Type", "ISSN", "IDDOI", "IDJGlobalID", "IDNAIDCiNiiID", "IDPMID", "Permalink", "URL", "Abstract_JP", "Abstract_EN"];
opts.VariableTypes = ["string", "string", "string", "string", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify variable properties
opts = setvaropts(opts, ["Title_JP", "Title_EN", "Author_JP", "Author_EN", "ISSN", "IDDOI", "IDJGlobalID", "IDNAIDCiNiiID", "IDPMID", "Permalink", "URL", "Abstract_JP", "Abstract_EN"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Title_JP", "Title_EN", "Author_JP", "Author_EN", "Journal_JP", "Journal_EN", "Language", "ISSN", "IDDOI", "IDJGlobalID", "IDNAIDCiNiiID", "IDPMID", "Permalink", "URL", "Abstract_JP", "Abstract_EN"], "EmptyFieldRule", "auto");

% Import the data
paper1 = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":X" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    paper1 = [paper1; tb]; %#ok<AGROW>
end

paper1 = paper1(~(paper1.Title_JP==""),:);
paper1.Year = datetime(num2str(paper1.Year),'InputFormat','yyyyMM');
paper1.Journal_JP = string(paper1.Journal_JP);
paper1.Journal_EN = string(paper1.Journal_EN);

end