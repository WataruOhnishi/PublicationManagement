# PublicationManagement
researchmap準拠のcsvを読み込んで業績リストのtxtファイルを出力するMATLAB functionです。
[publications.m](/docs/publications.m)を実行してください。

## 主なオプション
```
option.sort = 'descend'; % year sort. 'ascend' or 'descend'
option.num = true; % with number
option.inJP = false; % add (in Japanese) for Japanese article
option.lang = 'jp'; % output language 'en' or 'jp'
option.outOp = 'published'; % 'all', 'accepted', 'published'
option.format = 'standard'; % 'latex'
```

## 出力例
### paper.csv -> paper.txt
```
Journal paper (with review)
[1] 坂東太郎, 筑紫次郎: hogeに関する研究, hoge学会誌, Vol. 7, No. 2, pp. 109-116, 2018.
[2] 坂東太郎, 筑紫次郎: hogeに関する研究, hoge学会誌, Vol. 6, No. 1, pp. 109-116, 2018.
```

### misc.csv -> misc.txt
```
Conference paper (with review)
[1] Taro Bando, Tsukushi Jiro, Saburo Shikoku: Study on huga, International conference on hoge, pp. 1200-1205, 2018.
[2] Taro Bando, Tsukushi Jiro, Saburo Shikoku: Study on huga, International conference on hoge, pp. 1200-1205, 2017.

Domestic conference paper (without review)
[1] 坂東太郎, 筑紫次郎, 四国三郎: hogefugaに関する研究, hoge研究会, pp. 1-6, 2018.
[2] 坂東太郎, 筑紫次郎, 四国三郎: hogefugaに関する研究, hoge研究会, pp. 1-6, 2017.

Review paper
[1] 坂東太郎, 筑紫次郎: hogeの研究動向, hoge学会誌, Vol. 7, No. 2, pp. 109-116, 2018.

Others
[1] 坂東太郎, 筑紫次郎: hogeの訪問, hoge学会誌, Vol. 1, No. 1, pp. 109-116, 2018.
```

### prize.csv -> prize.txt
```
Award
[1] Paper award, YY, 2018/11/06.
[2] Paper award, XX, 2017/11/06.
```

### competitiveFund.csv -> competitiveFund.txt
```
Fund
[1] XX振興会, AA奨励費, ZZ2に関する研究, 代表者, 2018年度～2019年度, 300万円. 
[2] XX振興会, XX奨励費, ZZに関する研究, 代表者, 2015年度～2017年度, 300万円. 

Travel
[1] 公益財団法人YY, 渡航費支援, ZZに関する研究, 30万円. 
[2] 公益財団法人BB, 渡航費支援, ZZ2に関する研究, 30万円. 
```