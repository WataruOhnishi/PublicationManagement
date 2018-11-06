function paper = loadpaper(filename)

%% 変数を初期化します。
% filename = 'paper.csv';
delimiter = ',';
startRow = 2;

%% テキストの各行の書式設定:
%   列1: テキスト (%q)
%	列2: テキスト (%q)
%   列3: テキスト (%q)
%	列4: テキスト (%q)
%   列5: テキスト (%q)
%	列6: テキスト (%q)
%   列7: double (%f)
%	列8: double (%f)
%   列9: double (%f)
%	列10: double (%f)
%   列11: date
%	列12: カテゴリカル (%C)
%   列13: カテゴリカル (%C)
%	列14: カテゴリカル (%C)
%   列15: カテゴリカル (%C)
%	列16: テキスト (%q)
%   列17: テキスト (%q)
%	列18: テキスト (%q)
%   列19: テキスト (%q)
%	列20: テキスト (%q)
%   列21: テキスト (%q)
%	列22: テキスト (%q)
%   列23: テキスト (%q)
%	列24: テキスト (%q)
% 詳細は TEXTSCAN のドキュメンテーションを参照してください。
% formatSpec = '%q%q%q%q%q%q%f%f%f%f%f%C%C%C%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
formatSpec = '%q%q%q%q%q%q%q%q%q%q%{yyyyMM}D%C%C%C%C%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% テキスト ファイルを開きます。
fileID = fopen(filename,'r');

%% データの列を書式設定に従って読み取ります。
% この呼び出しは、このコードの生成に使用されたファイルの構造に基づいています。別のファイルでエラーが発生する場合は、インポート
% ツールからコードの再生成を試みてください。
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% テキスト ファイルを閉じます。
fclose(fileID);

%% インポートできないデータの後処理。
% インポート中に、インポートできないデータの規則が適用されなかったため、後処理コードが含まれていません。インポートできないデータに適用できるコードを生成するには、ファイル内のインポートできないセルを選択してからスクリプトを再生成します。

%% 出力変数の作成
% paper = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','VarName2','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','ISSN','IDDOI','IDJGlobalID','IDNAIDCiNiiID','IDPMID','Permalink','URL','VarName23','VarName24'});
paper = table(dataArray{1:end-1}, 'VariableNames', ...
    {'Title_JP','Title_EN','Author_JP','Author_EN','Journal_JP','Journal_EN',...
    'Vol','No','Page_ST','Page_ED','Year','Review','Invited','Language','Type',...
    'ISSN','IDDOI','IDJGlobalID','IDNAIDCiNiiID','IDPMID','Permalink','URL','VarName23','VarName24'});

end
