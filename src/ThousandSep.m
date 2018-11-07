function out = ThousandSep(in)
% https://jp.mathworks.com/matlabcentral/answers/100338-
import java.text.*
v = DecimalFormat;
data = [];
if length(in) == 1
    data = char(v.format(in));
else
    for n=1:length(in)
        data{n} = char(v.format(in(n)));
    end
end
out = data;
