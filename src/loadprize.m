function prize = loadprize(filename, startRow, endRow)
%IMPORTFILE テキスト ファイルから数値データを行列としてインポートします。
%   PRIZE = IMPORTFILE(FILENAME) 既定の選択については テキスト ファイル FILENAME
%   からデータを読み取ります。
%
%   PRIZE = IMPORTFILE(FILENAME, STARTROW, ENDROW) テキスト ファイル FILENAME の
%   STARTROW 行から ENDROW 行までのデータを読み取ります。
%
% Example:
%   prize = importfile('prize.csv', 2, 20);
%
%    TEXTSCAN も参照してください。

% MATLAB による自動生成 2018/11/06 18:53:27

%% 変数を初期化します。
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% テキストの各行の書式設定:
%   列1: datetime (%{yyyyMMdd}D)
%	列2: テキスト (%s)
%   列3: テキスト (%s)
%	列4: テキスト (%s)
%   列5: テキスト (%s)
%	列6: テキスト (%s)
%   列7: テキスト (%s)
%	列8: テキスト (%s)
%   列9: カテゴリカル (%C)
%	列10: カテゴリカル (%C)
%   列11: テキスト (%s)
%	列12: テキスト (%s)
%   列13: テキスト (%s)
%	列14: テキスト (%s)
% 詳細は TEXTSCAN のドキュメンテーションを参照してください。
formatSpec = '%{yyyyMMdd}D%s%s%s%s%s%s%s%C%C%s%s%s%s%[^\n\r]';

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

%% インポートできないデータの後処理。
% インポート中に、インポートできないデータの規則が適用されなかったため、後処理コードが含まれていません。インポートできないデータに適用できるコードを生成するには、ファイル内のインポートできないセルを選択してからスクリプトを再生成します。

%% 出力変数の作成
prize = table;
prize.Date = dataArray{:, 1};
prize.Institute_JP = cellstr(dataArray{:, 2});
prize.Institute_EN = cellstr(dataArray{:, 3});
prize.PrizeName_JP = cellstr(dataArray{:, 4});
prize.PrizeName_EN = cellstr(dataArray{:, 5});
prize.Title_JP = cellstr(dataArray{:, 6});
prize.Title_EN = cellstr(dataArray{:, 7});
prize.Name_JP = cellstr(dataArray{:, 8});
prize.Name_EN = dataArray{:, 9};
prize.Type = dataArray{:, 10};
prize.Country_JP = cellstr(dataArray{:, 11});
prize.Country_EN = cellstr(dataArray{:, 12});
prize.VarName13 = cellstr(dataArray{:, 13});
prize.VarName14 = cellstr(dataArray{:, 14});

% datetime ではなくシリアル日付 (datenum) がコードに必要な場合は、次の行のコメントを解除して、インポートした日付を
% datenum として返します。

% prize.Date=datenum(prize.Date);

