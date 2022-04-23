function [acf, lags] = autoCorrelation(data)
    % Hàm autoCorrelation nhận vào dữ liệu 1 khung tín hiệu
    % Trả về acf: dữ liệu sau khi dùng ACF và lags: độ trễ của tín hiệu.
    
    N = length(data);                                   % Độ dài khung tín hệu đầu vào (sample).
    lags = 0:N-1;                                          % Mảng độ trễ của tín hiệu.
    
    for i = 0: N-1                                          
        xx=0;                                                      
        for j = 1:N-i                                            
            s=data(j)*data(j+i);                           
            xx=xx+s;                                             
        end
        acf(i+1) = xx;                                      % Phần tử thứ i+1 của acf sẽ bằng giá trị của xx vừa tìm được. 
    end
    % ====     vẽ kết quả trung gian    ====
%     acf = ChuanHoaACF(acf);                     % Chuẩn hoá giá trị của các phần tử acf nằm trong [0,1]
    % ---------------------------------------------
%     acf = ChuanHoa(acf);                            % Chuẩn hoá giá trị của các phần tử acf nằm trong [-1,1]
%     stem(acf, 'filled');
%     title('Autocorrelation Function (handmade)');
%     xlabel('Lag (s)');
%     ylabel('Autocorrelation');
end