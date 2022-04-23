% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function Threshold = findThreshold(data)
% Hàm findThreshold nhận vào data không chứa silence
% Trả ra ngưỡng.
    [pks, ~] = findpeaks(data);
    Threshold =round(mean(pks), 3);
end