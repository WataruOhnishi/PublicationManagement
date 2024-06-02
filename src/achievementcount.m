function T = achievementcount(allpaper,awards)
    minYear = min(allpaper.Date.Year);
    maxYear = max(allpaper.Date.Year);
    years = (minYear:maxYear).';

    journals = allpaper(allpaper.Type == "scientific_journal",:);
    intConfs = allpaper(allpaper.Type == "international_conference_proceedings",:);
    domConfs = allpaper(allpaper.Type == "summary_national_conference",:);


    journals_counts = zeros(length(years),1);
    intConfs_counts = zeros(length(years),1);
    domConfs_counts = zeros(length(years),1);
    awards_counts = zeros(length(years),1);

    for k = 1:length(years)
        journals_counts(k) = sum(journals.Date.Year==years(k));
        intConfs_counts(k) = sum(intConfs.Date.Year==years(k));
        domConfs_counts(k) = sum(domConfs.Date.Year==years(k));
        awards_counts(k) = sum(awards.Date.Year==years(k));
    end

    journals_counts_cumsum = cumsum(journals_counts);
    intConfs_counts_cumsum = cumsum(intConfs_counts);
    domConfs_counts_cumsum = cumsum(domConfs_counts);
    awards_counts_cumsum = cumsum(awards_counts);

    T = table(years,journals_counts,intConfs_counts,domConfs_counts,awards_counts,...
        journals_counts_cumsum,intConfs_counts_cumsum,domConfs_counts_cumsum,awards_counts_cumsum);

    filename = 'achievementcount.xlsx';
    writetable(T,filename,'Sheet',1);

    [~, ~, ~] = mkdir(['./publications/',datestr(datetime('now'),'yyyymmdd')]);
    [~, ~, ~] = movefile(filename,['./publications/',datestr(datetime('now'),'yyyymmdd')],'f');    
end