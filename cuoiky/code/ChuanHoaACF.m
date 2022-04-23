% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function [data] = ChuanHoaACF(data)
    % Chuẩn hoá biên độ của tín hiệu truyền 
    % vào thành các giá trị nằm trong [0, 1]
    maxOfData = abs(max(data));
    minOfData = abs(min(data));
    
    L = length(data);
    
    if maxOfData > minOfData
        temp = maxOfData;
    else 
        temp = minOfData;
    end
    
    for i=1:L
        if data(i) >= 0
            data(i) = data(i)/abs(temp);
        else 
            data(i) = -(data(i))/abs(temp);
        end
    end
end