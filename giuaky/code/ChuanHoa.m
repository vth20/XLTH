% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function [data, temp] = ChuanHoa(data)
    % Chuẩn hoá biên độ của tín hiệu truyền 
    % vào thành các giá trị nằm trong [-1, 1]
    maxOfData = abs(max(data));
    minOfData = abs(min(data));
    
    if maxOfData > minOfData
        temp = maxOfData;
    else 
        temp = minOfData;
    end
    data=data / abs(temp);
end