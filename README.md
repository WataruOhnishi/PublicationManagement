# PublicationManagement
[Researchmap v2準拠のcsv](https://researchmap.jp/outline/v2api/v2CSV.pdf)を読み込んで業績リストのtxtファイルを出力するMATLAB functionです。
[publications.m](/docs/publications.m)を実行してください。

また，Markdownの出力機能もあり，GitHub PagesとJekyllを使うと[このようなページ](https://wataruohnishi.github.io/research)を簡単に生成できます。

## 主なオプション
```
op_paper.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_paper.num = 1; % with number
op_paper.inJP = 1; % add (in Japanese) for Japanese article
op_paper.lang = 'jpn'; % output language 'en' or 'jp'
op_paper.outOp = 'all'; % 'all', 'accepted', 'published'
op_paper.format = 'standard'; % standard, utcv
dateExtract = true;
dateFrom = datetime(2010,1,1);
dateTo = datetime(2023,9,31);
op_paper.dateExtract = dateExtract; 
op_paper.dateFrom = dateFrom; 
op_paper.dateTo = dateTo; 
op_paper.paperTitle = true;
```

## 出力例
### rm_journal_paper.csv, rm_international_conference_papers.csv, rm_misc.csv -> publications.txt
```
Journal paper (with review)
[1] Wataru Ohnishi, Nard Strijbosch, Tom Oomen: State-Tracking Iterative Learning Control in Frequency Domain Design for Improved Intersample Behavior, International Journal of Robust and Nonlinear Control, 2022.
[2] Wataru Ohnishi, Yuki Inada, Shungo Zen, Reon Sasaki, Yasuhiro Takada, Yuta Miyaoka, Kosuke Tsukamoto, Yasushi Yamano: Proof-of-Concept of a Fuse-Semiconductor Hybrid Circuit Breaker with a Fast Fuse Exchanger, IEEE Transactions on Power Delivery, 2022.
[3] Wataru Ohnishi, Thomas Beauduin, Hiroshi Fujimoto: Preactuated Multirate Feedforward Control for Independent Stable Inversion of Unstable Intrinsic and Discretization Zeros, IEEE/ASME Transactions on Mechatronics, Vol. 24, No.2, pp. 863-871, 2019.

Conference paper (with review)
[1] Wataru Ohnishi, Nard Strijbosch, Tom Oomen: Multirate State Tracking for Improving Intersample Behavior in Iterative Learning Control, IEEE International Conference on Mechatronics, 2021.
[2] Wataru Ohnishi, Hiroshi Fujimoto: Review on multirate feedforward: model-inverse feedforward control for nonminimum phase systems, The 4th IEEJ international workshop on Sensing, Actuation, Motion Control, and Optimization, pp. 1-6, 2018.

Domestic conference paper (without review)
[1] 大西亘, 平田輝, 柴辻亮介, 山口達也: 半導体熱処理成膜装置のヒーター・クーラー統合による高速高精度温度制御法の提案, 電気学会メカトロニクス制御研究会資料（電気学会研究会資料）, pp. 73-78, 2022. (in Japanese)
[2] 大西亘,藤本博志,古関隆章: コロナ禍における制御工学教育のオンライン・ハイブリッド実施の一事例, 電気学会研究会資料（制御／産業計測制御合同研究会）, pp. 9-14, 2021. (in Japanese)
[3] 大西亘, 藤本博志: 連続時間不安定零点を持つ制御対象への軌道追従制御法―冗長次数多項式軌道による最適有限Preactuation 法―, 電気学会メカトロニクス制御研究会資料（電気学会研究会資料）, pp. 1-6, 2016. (in Japanese)

Review paper

Others
```

### rm_awards.csv -> awards.txt
```
Award
[1] 開閉保護研究発表賞, 電気学会開閉保護技術委員会, 2022/01/24.
[2] 産業応用部門論文賞, 電気学会産業応用部門, 2020/08/25.
[3] 研究開発奨励賞　選考委員会特別賞, 一般財団法人　エヌエフ基金, 2018/11/16.
[4] 工学系研究科長賞（研究）, 東京大学大学院工学系研究科, 2018/03/22.
```

### rm_research_projects.csv -> competitiveFund.txt
```
Fund
[1] 日本学術振興会, 若手研究, システム同定と機械学習の連携による繰り返し学習制御の位置決め性能と汎化性能の両立, 2021年度～2023年度, 468万円 (代表者). 
[2] 日本学術振興会, 研究活動スタート支援, 次世代精密位置決め装置のための複数入出力を用いたデータ駆動形制御器自動設計法, 2018年度～2019年度, 299万円 (代表者). 
[3] 日本学術振興会, 特別研究員奨励費, 次世代半導体・液晶製造装置のための機構と制御の統合設計, 2015年度～2017年度, 340万円 (代表者). 
```
