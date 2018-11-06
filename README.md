# PublicationManagement
researchmap準拠のcsvを読み込んで業績リストのtxtファイルを出力するMATLAB functionです。

## 主なオプション
```
option.Sort = 'descend'; % year sort. 'ascend' or 'descend'
option.Num = 1; % with number
option.inJP = 0; % add (in Japanese) for Japanese article
option.Language = 'jp'; % 'en' or 'jp'
option.OutOptions = 'published'; % 'all', 'accepted', 'published'
option.format = 'standard';
```

## 出力例
### paper.csv
```
Journal paper (with review)
[1] 坂東太郎, 筑紫次郎: hogeに関する研究, hoge学会誌, Vol. 7, No. 2, pp. 109-116, 2018.

Conference paper (with review)
[1] Taro Bando, Tsukushi Jiro, Saburo Shikoku: Study on huga, International conference on hoge, pp. 1200-1205, 2018.

Domestic conference paper (without review)
[1] 坂東太郎, 筑紫次郎, 四国三郎: hogefugaに関する研究, hoge研究会, pp. 1-6, 2018.
```

### misc.csv
```
Review paper
[1] 坂東太郎, 筑紫次郎: hogeの研究動向, hoge学会誌, Vol. 7, No. 2, pp. 109-116, 2018.

Others
```

### prize.csv
```
Award
[1] Paper award, ほげ, 2018/11/06.
```
