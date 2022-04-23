% Ho va ten: Huynh Van Thanh - 19PFIEV3
% MSSV      : 123190109
% =========================

clc;
clear; close all;

for file=1:4
    if file==1
        path = ('./TinHieuKiemThu/phone_F2.wav');
        id_FrameVoiced = 115;
        id_FrameUnvoiced = 108;
        speech = [1.02, 4.04];
        figure('Name','phone_F2','NumberTitle','off');
    end
    if file==2
        path = ('./TinHieuKiemThu/phone_M2.wav');
        id_FrameVoiced = 89;
        id_FrameUnvoiced = 95;
        speech = [0.53, 2.52];
        figure('Name','phone_M2','NumberTitle','off');
    end
    if file==3
        path = ('./TinHieuKiemThu/studio_F2.wav');
        id_FrameVoiced = 40;
        id_FrameUnvoiced = 72;
        speech = [0.77, 2.37];
        figure('Name','studio_F2','NumberTitle','off');
    end
    if file==4
        path = ('./TinHieuKiemThu/studio_M2.wav');
        id_FrameVoiced = 40;
        id_FrameUnvoiced = 54;
        speech = [0.45, 1.93];
        figure('Name','studio_M2','NumberTitle','off');
    end
    % Đọc file.
    [data, fs] = audioread(path);
    
    % Tạo times để vẽ ra data.
    T = 1/fs;
    L = length(data)/fs;
    times = 0:T:L;
    
    % Chuẩn hoá dữ liệu.
    data = ChuanHoa(data);
   
    % Chia khung.
    time_frame = 0.025;
    frames = ChiaKhung(data, fs, time_frame);
    
    % Kích thước của frames.
    [row, col] = size(frames);                            % row chứa số khung, col chứ số mẫu 1 khung.
    
    % Lấy ra data không có silence.
    n = round(time_frame * fs);                        % Số mẫu của 1 frame.
    frameStart = round(speech(1) / time_frame);         % Lấy ra khung tương ứng
    frameEnd = round(speech(2) / time_frame);           % Lấy ra khung tương ứng
    idStart = ( frameStart - 1 ) * n + 1;            % Phần tử đầu tiên của frameStart.
    idEnd = ( frameEnd - 1 ) * n;                       % Phần tử cuối cùng của frameEnd.
    dataSpeech = data(idStart : idEnd);           % dataSpeech không chứa các khoảng silence.
    
    % Chọn ngưỡng.
    Threshold = findThreshold(dataSpeech);
    %Threshold = 0.04;                                      %Giá trị dùng chung. Là giá trị trung bình của 4
                                                                            %ngưỡng tìm được.
    
    % Vẽ signal đã qua chuẩn hoá kèm theo ngưỡng.
    subplot(4,1,2);
    plot(times(1:end-1),data);
%     axis([0 inf -1 1]);
%     hold on
%     plot( times(1:end-1), 0*times(1:end-1)+Threshold, 'r');
%     hold on
%     plot( times(1:end-1), 0*times(1:end-1)-Threshold, 'r');
%     axis([0 inf -1 1]);
    title('Tín hiệu đã chuẩn hoá');
    xlabel('Times (s)');
    ylabel('Amplitude');
%     legend('Signal', 'Threshold');
    
    
    % Display Theshold.
    if file == 1
        disp(['Threshold of Phone_F2: ', num2str(Threshold)]);
        nameFigure2= 'Phone F2';
    end
    if file == 2
        disp(['Threshold of Phone_M2: ', num2str(Threshold)]);
        nameFigure2= 'Phone M2';
    end
    if file == 3
        disp(['Threshold of Studio_F2: ', num2str(Threshold)]);
        nameFigure2= 'Studio F2';
    end
    if file == 4
        disp(['Threshold of Studio_M2: ', num2str(Threshold)]);
        nameFigure2= 'Studio M2';
    end
    
    % Vẽ khung voice.
    subplot(4,1,3);
    frameVoice = frames(id_FrameVoiced,:);
    [acf, lag] = autoCorrelation(frameVoice);
    acf = ChuanHoa(acf);
    
    plot(lag, acf);
    axis([0 inf -1 1]);
    title('Khung Voice dùng ACF');
    xlabel('Lag (s)');
    ylabel('Autocorrelation');
    legend('Signal');
    
    
    % Vẽ khung unvoiced.
     subplot(4,1,4);
    frameUnvoice = frames(id_FrameUnvoiced,:);
    [acf, lag] = autoCorrelation(frameUnvoice);
    acf = ChuanHoa(acf);
    
    plot(lag, acf);
    axis([0 inf -1 1]);
    title('Khung Unvoice dùng ACF');
    xlabel('Lag (s)');
    ylabel('Autocorrelation');
    legend('Signal');
    
    % Tính ACF cho từng khung.
    arrayF0 = ones(1, row)*(-inf);                     % Khởi tạo mảng F0_raw với row phần tử 0.
    for i=1:row
        frame = frames(i, :);                                                               % Lấy ra frame để xử lý.
        [acf_Frame, lag_Frame] = autoCorrelation(frame);           % Tính ACF cho frame.
        [value_Peak, id_Peak] = TimDinhCucBo(acf_Frame);        % Tìm đỉnh cục bộ của frame.
        if value_Peak >= Threshold                                                  % Kiểm tra đỉnh cục bộ có lớn hơn ngưỡng.
            F0 = TimF0(id_Peak, fs, time_frame);                                     % Tính F0 bằng hàm TimF0.
            if  70 < F0 && F0 < 400                                                          % So sánh F0 vừa tìm được với khoảng giới hạn đề cho.
                arrayF0(i) = F0;                                                                      % Thoả điều kiện thì gán F0 tìm được cho mảng F0.
            end
        end
    end
    
    % Vẽ F0 tìm được và in ra số liệu F0mean, F0sdt.
    [F0mean, F0std] = findMeanStd(arrayF0);
    
    subplot(4,1,1);
    plot(1:row, arrayF0, '.');
    axis([0 row 0 400]);
    title({['F0mean = ',num2str(F0mean),' - F0std = ',num2str(F0std)]});
    xlabel('frame');
    ylabel('Hz');
    legend('F0');
end