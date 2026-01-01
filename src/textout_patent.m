function textout_patent(filename)
%TEXTOUT_PATENT
% Read rm_industrial_property_rights.csv (header row may not be first),
% filter rows where 公開の有無 == disclosed,
% output patents.md (JP only),
% sort newest -> oldest,
% then move to ./publications/yyyyMMdd/
%
% Usage:
%   textout_patent('data/rm_industrial_property_rights.csv')

%% ---------- Load CSV ----------
C = readcell(filename, "FileType", "text");
if isempty(C) || size(C,1) < 3
    error("CSV seems too small or empty: %s", filename);
end

%% ---------- Detect header row (find row containing '公開の有無') ----------
headerRow = 0;
maxScan = min(20, size(C,1));
for r = 1:maxScan
    rowStr = strtrim(string(C(r,:)));
    if any(rowStr == "公開の有無") || any(contains(rowStr, "公開の有無"))
        headerRow = r;
        break;
    end
end
if headerRow == 0
    error("Header row not found (could not detect '公開の有無').");
end

rawHeader = C(headerRow, :);
data      = C(headerRow+1:end, :);

%% ---------- Build header names (handle missing/empty) ----------
ncol = numel(rawHeader);
header = strings(1, ncol);
for j = 1:ncol
    v = rawHeader{j};
    if ismissing(v)
        header(j) = "Var" + j;
    elseif ischar(v)
        if isempty(strtrim(v)), header(j)="Var"+j; else, header(j)=string(v); end
    elseif isstring(v)
        if numel(v)~=1 || strlength(v)==0, header(j)="Var"+j; else, header(j)=v; end
    else
        header(j) = string(v);
        if strlength(strtrim(header(j)))==0, header(j)="Var"+j; end
    end
end

vnames = matlab.lang.makeValidName(header, "ReplacementStyle","delete");
vnames = matlab.lang.makeUniqueStrings(vnames, {}, namelengthmax);

T = cell2table(data, "VariableNames", cellstr(vnames));
H = containers.Map(cellstr(header), cellstr(vnames)); % original header -> table varname

%% ---------- Required columns ----------
mustHave = @(name) assert(isKey(H,name), "Missing column (header): %s", name);

mustHave("公開の有無");
mustHave("産業財産権名(日本語)");
mustHave("発明者/考案者/創作者(日本語)");

pubCol    = H("公開の有無");
titleCol  = H("産業財産権名(日本語)");
authorCol = H("発明者/考案者/創作者(日本語)");

%% ---------- Filter disclosed ----------
pub = string(T.(pubCol));
mask = strcmpi(strtrim(pub), "disclosed");
Td = T(mask,:);
n = height(Td);

%% ---------- Choose identifier text (and normalize prefix like "特願") ----------
idText = strings(n,1);
candHeaders = ["出願番号","公表番号","公開番号","特許番号/登録番号","ID"];

for k = 1:n
    chosen = "";
    chosenType = ""; % which column we used
    for nm = candHeaders
        if isKey(H, nm)
            s = strtrim(string(Td.(H(nm))(k)));
            if ~ismissing(s) && strlength(s)>0 && lower(s)~="nan"
                chosen = s;
                chosenType = nm;
                break;
            end
        end
    end
    idText(k) = normalizeId(chosen, chosenType);
end

%% ---------- Title / Authors ----------
title_jp  = string(Td.(titleCol));
author_jp = cleanAuthors(string(Td.(authorCol)));

%% ---------- Sort newest -> oldest ----------
% Prefer: 出願日 > 公開日 > 登録日. If none, try extracting year from id.
sortKey = NaT(n,1);

% helper to parse date columns if exist
sortKey = fillDateKey(sortKey, Td, H, "出願日");
sortKey = fillDateKey(sortKey, Td, H, "公開日");
sortKey = fillDateKey(sortKey, Td, H, "登録日");

% For rows still NaT, try year from id text (e.g., 特願2022-xxxxx)
idxNaT = isnat(sortKey);
if any(idxNaT)
    sortKey(idxNaT) = yearFromIdAsDate(idText(idxNaT));
end

% Sort desc; NaT goes to bottom
[~, order] = sort(sortKey, "descend", "MissingPlacement","last");
Td = Td(order,:);
idText = idText(order);
title_jp = title_jp(order);
author_jp = author_jp(order);

%% ---------- Build Markdown ----------
lines = strings(n + 2, 1);
lines(1) = "# 特許";
lines(2) = "";

for k = 1:n
    lines(k+2) = "1." + char(9) + idText(k) + ": " + author_jp(k) + ": " + title_jp(k);
end

md = strjoin(lines, newline);

%% ---------- Write md (patents.md) ----------
outFile = "patents.md";
fid = fopen(outFile, "w");
if fid < 0
    error("Failed to open output file: %s", outFile);
end
fwrite(fid, md, "char");
fclose(fid);

%% ---------- mkdir & movefile ----------
outDir = fullfile("./publications", datestr(datetime("now"), "yyyymmdd"));
[~, ~, ~] = mkdir(outDir);
[~, ~, ~] = movefile(outFile, outDir, "f");

fprintf("✔ wrote %d disclosed items -> %s\n", n, outDir);

end

%% ===== helper: clean author strings =====
function a = cleanAuthors(a)
a = string(a);
a = strrep(a,"[","");
a = strrep(a,"]","");
a = strrep(a,"，",",");
a = strrep(a,"、",",");
a = strrep(a,";",",");
a = regexprep(a,"\s+", " ");
a = strtrim(a);
end

%% ===== helper: normalize identifier prefix =====
function out = normalizeId(raw, usedType)
raw = strtrim(string(raw));
if strlength(raw)==0 || ismissing(raw) || lower(raw)=="nan"
    out = "";
    return;
end

% If it already starts with typical prefixes, keep as-is
prefixes = ["特願","特開","特許","実願","意願","国際特許出願","PCT/","PCT","WO"];
for p = prefixes
    if startsWith(raw, p, "IgnoreCase", false)
        out = raw;
        return;
    end
end

% Otherwise, add "特願" for application-like identifiers
% If we used 出願番号 or ID, we likely want "特願"
if usedType == "出願番号" || usedType == "ID"
    out = "特願" + raw;
else
    % 公開番号や公表番号、登録番号は “特願” 固定が不自然なことがあるのでそのまま
    out = raw;
end
end

%% ===== helper: fill date key from a date column if present =====
function key = fillDateKey(key, Td, H, colName)
if ~isKey(H, colName)
    return;
end
v = Td.(H(colName));
s = string(v);
for i = 1:numel(s)
    if isnat(key(i))
        dt = parseAnyDate(s(i));
        if ~isnat(dt)
            key(i) = dt;
        end
    end
end
end

%% ===== helper: parse date from string/number (robust) =====
function dt = parseAnyDate(x)
dt = NaT;

% numeric excel serial?
if isnumeric(x)
    try
        dt = datetime(x, "ConvertFrom","excel");
    catch
    end
    return;
end

s = strtrim(string(x));
if ismissing(s) || strlength(s)==0 || lower(s)=="nan"
    return;
end

% Common patterns
fmts = ["yyyyMMdd","yyyy/MM/dd","yyyy-MM-dd","yyyy.MM.dd","yyyyMM","yyyy/MM","yyyy"];
for f = fmts
    try
        dt = datetime(s, "InputFormat", f, "Locale","ja_JP");
        return;
    catch
    end
end

% As last resort, try datetime's auto parsing
try
    dt = datetime(s, "Locale","ja_JP");
catch
end
end

%% ===== helper: derive a date from id's year (e.g., 特願2022-xxxx) =====
function dt = yearFromIdAsDate(idText)
dt = NaT(size(idText));
for i = 1:numel(idText)
    s = string(idText(i));
    % extract first 4-digit year between 1900-2099
    m = regexp(s, "(19\d{2}|20\d{2})", "match", "once");
    if ~isempty(m)
        try
            dt(i) = datetime(m, "InputFormat","yyyy", "Locale","ja_JP");
        catch
        end
    end
end
end
