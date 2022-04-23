% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function [F0mean, F0std] = findMeanStd(data)
% Hàm findMeanStd nhận vào mảng các F0
% Trả ra giá trị Mean và Std sau khi lọc.
    count =1;
    L = length(data);
    for i=1:L
        if 70 < data(i) && data(i) < 400
            temp(count) = data(i);
            count = count +1;
        end
    end
    
    F0mean = round(mean(temp), 2);
    F0std = round(std(temp), 2);
end