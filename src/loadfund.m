function competitiveFund = loadfund(filename, startRow, endRow)
%IMPORTFILE テキスト ファイルから数値データを行列としてインポートします。
%   COMPETITIVEFUND = IMPORTFILE(FILENAME) 既定の選択については テキスト ファイル FILENAME
%   からデータを読み取ります。
%
%   COMPETITIVEFUND = IMPORTFILE(FILENAME, STARTROW, ENDROW) テキスト ファイル
%   FILENAME の STARTROW 行から ENDROW 行までのデータを読み取ります。
%
% Example:
%   competitiveFund = importfile('competitiveFund.csv', 2, 8);
%
%    TEXTSCAN も参照してください。

% MATLAB による自動生成 2018/11/07 17:51:05

%% 変数を初期化します。
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% データの列をテキストとして読み取る:
% 詳細は TEXTSCAN のドキュメンテーションを参照してください。
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% テキスト ファイルを開きます。
fileID = fopen(filename,'r');

%% データの列を書式設定に従って読み取ります。
% この呼び出しは、このコードの生成に使用されたファイルの構造に基づいています。別のファイルでエラーが発生する場合は、インポート
% ツールからコードの再生成を試みてください。
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% テキスト ファイルを閉じます。
fclose(fileID);

%% 数値テキストを含む列の内容を数値に変換します。
% 非数値テキストを NaN で置き換えます。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[11,12,13]
    % 入力セル配列のテキストを数値に変換します。非数値テキストを NaN で置き換えました。
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % 数値でない接頭辞と接尾辞を検出して削除する正規表現を作成します。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % 桁区切り以外の場所でコンマが検出されました。
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 数値テキストを数値に変換します。
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

dateFormatIndex = 1;
blankDates = cell(1,size(raw,2));
anyBlankDates = false(size(raw,1),1);
invalidDates = cell(1,size(raw,2));
anyInvalidDates = false(size(raw,1),1);
for col=[7,8]% 日付をもつ列の内容を、指定の日付形式を使用して MATLAB datetime に変換します。
    try
        dates{col} = datetime(dataArray{col}, 'Format', 'yyyyMMdd', 'InputFormat', 'yyyyMMdd'); %#ok<AGROW>
    catch
        try
            % 引用符で囲まれた日付の処理
            dataArray{col} = cellfun(@(x) x(2:end-1), dataArray{col}, 'UniformOutput', false);
            dates{col} = datetime(dataArray{col}, 'Format', 'yyyyMMdd', 'InputFormat', 'yyyyMMdd'); %#ok<AGROW>
        catch
            dates{col} = repmat(datetime([NaN NaN NaN]), size(dataArray{col})); %#ok<AGROW>
        end
    end
    
    dateFormatIndex = dateFormatIndex + 1;
    blankDates{col} = dataArray{col} == '';
    anyBlankDates = blankDates{col} | anyBlankDates;
    invalidDates{col} = isnan(dates{col}.Hour) - blankDates{col};
    anyInvalidDates = invalidDates{col} | anyInvalidDates;
end
dates = dates(:,[7,8]);
blankDates = blankDates(:,[7,8]);
invalidDates = invalidDates(:,[7,8]);

%% データを数値の列と string の列に分割します。
rawNumericColumns = raw(:, [11,12,13]);
rawStringColumns = string(raw(:, [1,2,3,4,5,6,9,10,14,15,16,17,18]));


%% <undefined> を含むテキストが <undefined> カテゴリカルに適切に変換されていることを確認してください
for catIdx = [12,13]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% 出力変数の作成
competitiveFund = table;
competitiveFund.Institute_JP = cellstr(rawStringColumns(:, 1));
competitiveFund.Institute_EN = cellstr(rawStringColumns(:, 2));
competitiveFund.FundName_JP = cellstr(rawStringColumns(:, 3));
competitiveFund.FundName_EN = cellstr(rawStringColumns(:, 4));
competitiveFund.Title_JP = cellstr(rawStringColumns(:, 5));
competitiveFund.Title_EN = cellstr(rawStringColumns(:, 6));
competitiveFund.From = dates{:, 1};
competitiveFund.To = dates{:, 2};
competitiveFund.Name_JP = cellstr(rawStringColumns(:, 7));
competitiveFund.Name_EN = cellstr(rawStringColumns(:, 8));
competitiveFund.Budget_all = cell2mat(rawNumericColumns(:, 1));
competitiveFund.Budget_direct = cell2mat(rawNumericColumns(:, 2));
competitiveFund.Budget_indirect = cell2mat(rawNumericColumns(:, 3));
competitiveFund.Permalink = cellstr(rawStringColumns(:, 9));
competitiveFund.Abstract_JP = cellstr(rawStringColumns(:, 10));
competitiveFund.Abstract_EN = cellstr(rawStringColumns(:, 11));
competitiveFund.Type = categorical(rawStringColumns(:, 12));
competitiveFund.MemberType = categorical(rawStringColumns(:, 13));

% datetime ではなくシリアル日付 (datenum) がコードに必要な場合は、次の行のコメントを解除して、インポートした日付を
% datenum として返します。

% competitiveFund.From=datenum(competitiveFund.From);
% competitiveFund.To=datenum(competitiveFund.To);

