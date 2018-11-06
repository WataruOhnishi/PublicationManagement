% publications
clear; close;

op_paper.Sort = 'descend'; % year sort. 'ascend' or 'descend'
op_paper.Num = 1; % with number
op_paper.inJP = 0; % add (in Japanese) for Japanese article
op_paper.Language = 'jp'; % 'en' or 'jp'
op_paper.OutOptions = 'published'; % 'all', 'accepted', 'published'
op_paper.format = 'standard'; % 
[paper,jpaper_out,conf_out,domconf_out] = txtout_paper(op_paper);
[misc,review_out,other_out] = txtout_misc(op_paper);

op_prize.Sort = 'descend'; % year sort. 'ascend' or 'descend'
op_prize.format = 'standard'; % 
op_prize.Language = 'jp'; % 'en' or 'jp'
op_prize.name = 0; % with name or not
op_prize.Num = 1; % with number
[prize,prize_out] = txtout_prize(op_prize);

