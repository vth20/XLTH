% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

clc;
clear; close all;

for file=1:4
    if file==1
        path = ('./TinHieuKiemThu/30FTN.wav');
        standard = [0.59 0.97 1.76 2.11 3.44 3.77 4.7 5.13 5.96 6.28];
        id_FrameVoiced = 80;
        id_FrameUnvoiced = 100;
        figure('Name','30FTN','NumberTitle','off');
    end
    if file==2
        path = ('./TinHieuKiemThu/42FQT.wav');
        standard = [0.46 0.99 1.56 2.13 2.51 2.93 3.79 4.38 4.77 5.22];
        id_FrameVoiced = 156;
        id_FrameUnvoiced = 130;
        figure('Name','42FQT','NumberTitle','off');
    end
    if file==3
        path = ('./TinHieuKiemThu/44MTT.wav');
        standard = [0.93 1.42 2.59 3 4.71 5.11 6.26 6.66 8.04 8.39];
        id_FrameVoiced = 196;
        id_FrameUnvoiced = 150;
        figure('Name','44MTT','NumberTitle','off');
    end
    if file==4
        path = ('./TinHieuKiemThu/45MDV.wav');
        standard = [0.88 1.34 2.35 2.82 3.76 4.13 5.04 5.5 6.41 6.79];
        id_FrameVoiced = 40;
        id_FrameUnvoiced = 180;
        figure('Name','45MDV','NumberTitle','off');
    end
    % Đọc file.
    [data, fs] = audioread(path);
    
    % Tạo times để vẽ ra data.
    T = 1/fs;
    L = length(data)/fs;
    times = 0:T:L;
    
    % Chuẩn hoá dữ liệu về -1:1.
    data = ChuanHoa(data);
   
    % Chia khung.
    time_frame = 0.025;
    frames = ChiaKhung(data, fs, time_frame);
    
    % Kích thước của frames.
    [row, col] = size(frames);                            % row chứa số khung, col chứ số mẫu 1 khung.
    
    % Chọn ngưỡng.
    Threshold = findThreshold(data, fs);
    %Threshold = 0.0036;                                      %Giá trị dùng chung. Là giá trị trung bình của 4
                                                                            %ngưỡng tìm được.
                                                                            
    
    
    % Display Theshold.
    if file == 1
        disp(['Threshold of file 30FTN: ', num2str(Threshold)]);
        nameFigure2= 'Phone F2';
    end
    if file == 2
        disp(['Threshold of file 42FQT: ', num2str(Threshold)]);
        nameFigure2= 'Phone M2';
    end
    if file == 3
        disp(['Threshold of file 44MTT: ', num2str(Threshold)]);
        nameFigure2= 'Studio F2';
    end
    if file == 4
        disp(['Threshold of file 45MDV: ', num2str(Threshold)]);
        nameFigure2= 'Studio M2';
    end
    
    % Tính ACF cho từng khung.
    arrayF0 = ones(1, row)*(-inf);                     % Khởi tạo mảng F0_raw với row phần tử 0.
    list = zeros(1, row);                                       % list chứa địa chỉ các khung là tiếng nói.
    for i=1:row
        frame = frames(i, :);                                                               % Lấy ra frame để xử lý.
        [acf_Frame, lag_Frame] = autoCorrelation(frame);           % Tính ACF cho frame.
        [value_Peak, id_Peak] = TimDinhCucBo(acf_Frame);        % Tìm đỉnh cục bộ của frame.
        if value_Peak >= Threshold                                                  % Kiểm tra đỉnh cục bộ có lớn hơn ngưỡng.
            F0 = TimF0(id_Peak, fs, time_frame); 
            list(i) = 1;
            % Tính F0 bằng hàm TimF0.
            if  70 < F0 && F0 < 400                                                          % So sánh F0 vừa tìm được với khoảng giới hạn đề cho.
                arrayF0(i) = F0;                                                                      % Thoả điều kiện thì gán F0 tìm được cho mảng F0.
            end
        end
    end
    
    % Lọc ra các trường hợp gây ra các biên ảo.
    newList = LocNhieu(list);
    
    % Vẽ signal đã qua chuẩn hoá và biên.
    subplot(4,1,3);
    plot(times(1:end-1),data);
    axis([0 inf -1 1]);
    title('Output signal');
    xlabel('Times (s)');
    ylabel('Amplitude');
    hold on;
    for i = 1:row-1
        % ví dụ: 00 |1111111| 0000 |1111111| 0000
        if ((newList(i)==0 && newList(i+1)==1) || (newList(i)==1 && newList(i+1)==0)  )
            plot([1 1]*i*time_frame, ylim, 'g','linewidth',1.5); 
        end
    end
    hold on;
    for i = 1:length(standard)
        plot([1 1]*standard(i), ylim, 'r','linewidth',1.2);
    end
    legend('signal', 'By student');
    
    % Tạo newData chứa các khoảng tiếng nói.
    newData = zeros(row,col);             % Khởi tạo với giá trị mặc định bằng 0.
    n = round(time_frame * fs);           % Số mẫu của 1 frame
    L = length(data);                              % Độ dài của tín hiệu
    N_frame = floor(L/n);                      % Số khung của một tín hiệu
     
     for i = 1 : N_frame
     	if (newList(i) == 1)                          % Chỉ lấy khung hữu thanh.
            newData(i,:) = data((i-1)*n+1:i*n);
        end
     end
    
     % Thuật toán 2.
     h=hamming(n);
     fft_points = 1024;
     
     F0_spectrum=ones(1,N_frame)*(-inf);                 % Tạo list F0 theo phổ
     
     for i=1:row
        if(newList(i)==1) 
            frame_hamm=h.*data(n*(i-1)+1:n*i);          % Chuyển qua cửa sổ hamming.
            
            dfty=abs(fft(frame_hamm, fft_points)); % get samples of magnitude spectrum
            logDfty=10*log10(dfty);
            k=1:fft_points; % k axis
            w=k*fs/fft_points; % frequency axis
            
            
              % Dùng Savitzky-Golay filtering cho dfty.
                [peaks,loc] = findpeaks(logDfty, 'MinPeakDistance', 2);
                temp=1;
                for j=2:51                  % duyệt qua 50 đỉnh hài đầu tiên
                    value = loc(j) - loc(j-1);          % value chứa giá trị khoảng cách 2 hài liên tiếp
                    Distant(temp) = value;           % Distant là danh sách các khoảng cách       
                    temp=temp+1;
                end
                F0_value = mean(Distant)*fs/fft_points;        % F0 bằng giá trị trung bình của Distant*fs/fft_points.
                if F0_value>70 && F0_value<400                  % lọc lấy F0 trong khoảng 70 đến 400 Hz
                    F0_spectrum(i)=F0_value;                            % Đưa vào danh sách F0 của phổ.
                end
            end
     end
     
     % Vẽ đường F0 tìm được qua phổ.
     [F0mean, F0std] = findMeanStd(F0_spectrum);
     subplot(4,1,2)
     plot(1:row, F0_spectrum, '.');
     axis([0 row 0 400]);
     title({['Cuoi Ky - F0mean = ',num2str(F0mean),' - F0std = ',num2str(F0std)]});
     xlabel('frame');
     ylabel('Hz');
     legend('F0');
     
     
    %  Vẽ F0 tìm được và in ra số liệu F0mean, F0sdt. Theo ACF
    [F0mean, F0std] = findMeanStd(arrayF0);
    
    subplot(4,1,1);
    plot(1:row, arrayF0, '.');
    axis([0 row 0 400]);
    title({['Giua Ky - F0mean = ',num2str(F0mean),' - F0std = ',num2str(F0std)]});
    xlabel('frame');
    ylabel('Hz');
    legend('F0');
    
    
    % Vẽ khung voice.
    i=id_FrameVoiced;
    frame_hamm=h.*data(n*(i-1)+1:n*i);
    dfty=abs(fft(frame_hamm, fft_points)); % get samples of magnitude spectrum
    logDfty=10*log10(dfty);
    
    k=1:fft_points; % k axis
    w=k*fs/fft_points; % frequency axis
    subplot(4,2,7);
    plot(w(1:fft_points/2),logDfty(1:fft_points/2),'b','LineWidth',1);
    title('Linear Magnitude Spectrum of voice frame');
    xlabel('Frequency (Hz)')
    ylabel('Magnitude');

    
    % Vẽ khung unvoiced.
    i=id_FrameUnvoiced;
    frame_hamm=h.*data(n*(i-1)+1:n*i);
    subplot(4,2,8);
    dfty=abs(fft(frame_hamm, fft_points)); % get samples of magnitude spectrum
    logDfty=10*log10(dfty);
    k=1:fft_points; % k axis
    w=k*fs/fft_points; % frequency axis
    plot(w(1:fft_points/2),logDfty(1:fft_points/2),'b','LineWidth',1);
    title('Linear Magnitude Spectrum of unvoice frame');
    xlabel('Frequency (Hz)')
    ylabel('Magnitude');
end