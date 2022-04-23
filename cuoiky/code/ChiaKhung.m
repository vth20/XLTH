% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function [frames] = ChiaKhung(data, fs, time_frame)
    % Hàm chia khung với các tham số đầu vào: 
        % data: mảng các biên độ của tín hiệu.
        % fs: tần số trích mẫu của tín hiệu âm thanh.
        % time_frame: Thời gian của 1 khung (s)
     % Trả ra một ma trận với mỗi hàng là một khung
     
     n = round(time_frame * fs);           % Số mẫu của 1 frame
     L = length(data);                              % Độ dài của tín hiệu
     N_frame = floor(L/n);                      % Số khung của một tín hiệu
     
     for i = 1 : N_frame
     	frames(i,:) = data((i-1)*n+1:i*n);
     end
end