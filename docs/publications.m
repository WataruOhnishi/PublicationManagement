clear; close all; clc;

dateExtract = true;
dateFrom = datetime(2010,1,1);
dateTo = datetime(2023,9,31);

%% paper publications
op_paper.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_paper.num = 1; % with number
op_paper.inJP = 1; % add (in Japanese) for Japanese article
op_paper.lang = 'jpn'; % output language 'en' or 'jp'
op_paper.outOp = 'all'; % 'all', 'accepted', 'published'
op_paper.format = 'standard'; % standard, utcv
op_paper.dateExtract = dateExtract; 
op_paper.dateFrom = dateFrom; 
op_paper.dateTo = dateTo; 
op_paper.paperTitle = true;

[allpaper,jpaper_out,conf_out,domconf_out,review_out,other_out] = txtout_paper(op_paper);
papercount(allpaper);
papercount(allpaper,op_paper,false);

%% prise
op_awards.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_awards.format = 'standard'; % standard, utoversea, latex
op_awards.lang = 'jpn'; % 'en' or 'jp'
op_awards.name = false; % with name or not
op_awards.num = true; % with number
[awards,awards_out] = txtout_awards(op_awards);

%% competitiveFund
op_fund.sort = 'descend'; % year sort. 'ascend' or 'descend'
op_fund.num = true; % with number
op_fund.lang = 'jpn'; % 'en' or 'jp'
op_fund.format = 'standard'; % 
op_fund.title = true; % display title or not
op_fund.amount = 1; % display amount or not
op_fund.date = true; % display date or not
op_fund.role = true; % display role or not
[fund,fund_out] = txtout_fund(op_fund);


% Future update

% %% presentations.csv
% op_presen.sort = 'descend'; % year sort. 'ascend' or 'descend'
% op_presen.num = 1; % with number
% op_presen.name = true; % with name or not
% op_presen.lang = 'jp'; % 'en' or 'jp'
% op_presen.format = 'standard'; % 
% op_presen.title = true; % display title or not
% op_presen.date = true; % display date or not
% [presen,presen_out] = txtout_presen(op_presen);

% %% jointResearch
% op_joint.sort = 'descend'; % year sort. 'ascend' or 'descend'
% op_joint.num = false; % with number
% op_joint.format = 'standard'; % 
% op_joint.title = true; % display title or not
% op_joint.date = true; % display date or not
% [joint,joint_out] = txtout_joint(op_joint);
% 
