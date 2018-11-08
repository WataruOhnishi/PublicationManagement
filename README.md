# PublicationManagement
researchmap準拠のcsvを読み込んで業績リストのtxtファイルを出力するMATLAB functionです。

## 主なオプション
```
option.sort = 'descend'; % year sort. 'ascend' or 'descend'
option.num = true; % with number
option.inJP = false; % add (in Japanese) for Japanese article
option.lang = 'jp'; % output language 'en' or 'jp'
option.outOp = 'published'; % 'all', 'accepted', 'published'
option.format = 'standard'; % 
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

### competitiveFund.csv
```
Fund
[1] XX振興会, XX奨励費, ZZに関する研究, 代表者, 2015年度～2017年度, 300万円. 

Travel
[1] 公益財団法人YY, 渡航費支援, ZZに関する研究, 30万円. 
```