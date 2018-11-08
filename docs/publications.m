clear; close all;

%% paper.csv
op_paper.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_paper.num = true; % with number
op_paper.inJP = false; % add (in Japanese) for Japanese article
op_paper.lang = 'jp'; % output language 'en' or 'jp'
op_paper.outOp = 'published'; % 'all', 'accepted', 'published'
op_paper.format = 'standard'; % 
[paper,jpaper_out,conf_out,domconf_out] = txtout_paper(op_paper);
%% misc.csv
[misc,review_out,other_out] = txtout_misc(op_paper);

%% prise.csv
op_prize.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_prize.format = 'standard'; % 
op_prize.lang = 'jp'; % 'en' or 'jp'
op_prize.name = false; % with name or not
op_prize.num = true; % with number
[prize,prize_out] = txtout_prize(op_prize);
%% competitiveFund.csv
op_fund.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_fund.num = true; % with number
op_fund.lang = 'jp'; % 'en' or 'jp'
op_fund.format = 'standard'; % 
op_fund.title = true; % display title or not
op_fund.amount = true; % display amount or not
op_fund.date = true; % display date or not
[fund,fund_out,travel_out] = txtout_fund(op_fund);
