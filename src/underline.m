function out = underline(str, English, Japanese)
if nargin < 2
    English = textscan(fopen('ENname.txt'),'%s'); 
    English = [English{1}{1},' ', English{1}{2}];
    Japanese = textread('JPname.txt','%s');
end
out = strrep(str,English,['\underline{',English,'}']);
out = strrep(out{1},Japanese{1},['\underline{',Japanese{1},'}']);
% idx = strfind(out,Japanese{1});
% idx
% out
% if ~isempty(idx)
%     out = [out{1}(idx+3) '\underline{',Japanese{1},'}'];
% end


end
