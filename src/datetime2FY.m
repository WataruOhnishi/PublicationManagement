function FY = datetime2FY(dt)
    md = datetime(1,dt.Month,dt.Day);
    if md < datetime(1,4,1)
        FY = dt.Year - 1;
    else
        FY = dt.Year;
    end

end
