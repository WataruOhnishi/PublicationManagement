clear; close all; clc;

dateExtract = false;
% dateFrom = datetime(2018,4,1);
% dateTo = datetime(2019,3,31);

%% paper.csv
op_paper.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_paper.num = true; % with number
op_paper.inJP = false; % add (in Japanese) for Japanese article
op_paper.lang = 'jp'; % output language 'en' or 'jp'
op_paper.outOp = 'accepted'; % 'all', 'accepted', 'published'
op_paper.format = 'standard'; % latex, standard
op_paper.dateExtract = dateExtract; % latex, standard
% op_paper.dateFrom = dateFrom; % latex, standard
% op_paper.dateTo = dateTo; % date extract date to

[paper,jpaper_out] = txtout_paper(op_paper);

%% misc.csv
op_paper.outOp = 'accepted'; % 'all', 'accepted', 'published'
[misc,review_out,other_out] = txtout_misc(op_paper);

%% prise.csv
op_prize.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_prize.format = 'standard'; % standard, utoversea, latex
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
op_fund.amount = false; % display amount or not
op_fund.date = true; % display date or not
[fund,fund_out,travel_out] = txtout_fund(op_fund);
