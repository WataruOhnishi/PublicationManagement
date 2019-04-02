function conference = loadconf(filename, startRow, endRow)
%IMPORTFILE テキスト ファイルから数値データを行列としてインポートします。
%   CONFERENCE = IMPORTFILE(FILENAME) 既定の選択については テキスト ファイル FILENAME
%   からデータを読み取ります。
%
%   CONFERENCE = IMPORTFILE(FILENAME, STARTROW, ENDROW) テキスト ファイル FILENAME
%   の STARTROW 行から ENDROW 行までのデータを読み取ります。
%
% Example:
%   conference = importfile('conference.csv', 2, 9);
%
%    TEXTSCAN も参照してください。

% MATLAB による自動生成 2019/04/02 18:06:26

%% 変数を初期化します。
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% テキストの各行の書式設定:
%   列1: テキスト (%q)
%	列2: テキスト (%q)
%   列3: テキスト (%q)
%	列4: テキスト (%q)
%   列5: テキスト (%q)
%	列6: テキスト (%q)
%   列7: datetime (%{yyyy/mm/dd}D)
%	列8: double (%f)
%   列9: カテゴリカル (%C)
%	列10: カテゴリカル (%C)
%   列11: カテゴリカル (%C)
%	列12: テキスト (%q)
%   列13: テキスト (%q)
%	列14: テキスト (%q)
%   列15: テキスト (%q)
%	列16: テキスト (%q)
%   列17: テキスト (%q)
%	列18: テキスト (%q)
% 詳細は TEXTSCAN のドキュメンテーションを参照してください。
formatSpec = '%q%q%q%q%q%q%{yyyy/mm/dd}D%f%C%C%C%q%q%q%q%q%q%q%[^\n\r]';

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
conference = table(dataArray{1:end-1}, 'VariableNames', {'Title_JP','Title_EN','Name_JP','Name_EN','Confname_JP','Confname_EN','Date','Invited','Language','ConfLanguage','ConfType','Host_JP','Host_EN','Place_JP','Place_EN','URL','Abstract_JP','Abstract_EN'});

% datetime ではなくシリアル日付 (datenum) がコードに必要な場合は、次の行のコメントを解除して、インポートした日付を
% datenum として返します。

% conference.Date=datenum(conference.Date);

