% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function Threshold = findThreshold(data, fs)
% Hàm findThreshold nhận vào data
% Trả ra ngưỡng.
%   
% Chia khung.
    time_frame = 0.025;
    frames = ChiaKhung(data, fs, time_frame);
    
     % Kích thước của frames.
    [row, ~] = size(frames);                            % row chứa số khung.
    
    list = zeros(1, row);
    for i=1:row
        frame = frames(i, :);
        value = abs(max(frame)-min(frame))/2;           
        list(i) = value;
    end 
    Threshold = mean(list);
end