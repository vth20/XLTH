% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

function [value_Peak, id_Peak] = TimDinhCucBo(ac)
% Hàm TimDinhCucBo nhận vào acf của 1 frame, 
% trả ra giá trị của cực đại lớn nhất và vị trí của cực đại đó trong mảng.
    L = length(ac);                                    % L chứa độ dài của ac.
    value_Peak = 0;                                  % Khởi tạo giá trị cho biến value_Peak.
    id_Peak = 0;                                        % Khởi tạo giá trị cho biên id_Peak.
    for i=2:L-1
        if ac(i-1) < ac(i) && ac(i) > ac(i+1)               % Kiểm tra ac(i) có phải là cực trị hay không.
            if ac(i) > value_Peak                                                    % Kiểm tra ac(i) có lớn hơn maxValue hay không.
                value_Peak = ac(i);                                                   % Nếu đúng thì gán ac(i) cho maxValue
                id_Peak = i;                                                                % và gán i cho id.
            end
        end
    end
end