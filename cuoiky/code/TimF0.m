function value_F0 = TimF0(id_Peak, fs, time_frame)
% Hàm TimF0 nhận vào id_Peak: vị trí cực đại có giá trị lớn nhất
% fs: tần số của tín hiệu và time của 1 frame để tính ra số mẫu.
% Trả ra giá trị F0 tìm được.
  n = round(time_frame * fs);                    % Số mẫu của 1 frame
  T0 = id_Peak*time_frame/n;                   % Tính chu kỳ T0
  value_F0 = 1/T0;                                       % F0 sẽ bằng 1/T0
end