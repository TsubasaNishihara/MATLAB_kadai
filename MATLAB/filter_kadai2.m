clear;

%ファイルの読み込み
filename = '14_34_20check.txt';
data = readmatrix(filename,'NumHeaderLines',1,'Delimiter','\t'); %筋電データ
filename = '14_34_20para.txt'; 
paradt = readmatrix(filename,'Delimiter','\t'); %各パラメータ
t_max = data(end,1);        %測定時間
ch1 = data(1:end,2);
ch2 = data(1:end,3);
ch3 = data(1:end,4);
ch4 = data(1:end,5);
fs = paradt(2,2);           %サンプリング周波数
t = data(1:end,1) / fs;     %時間
dtsize = size(t,1);         %データのサイズ
ch1_offset = paradt(3,2);   %ch1のオフセット
ch2_offset = paradt(4,2);   %ch2のオフセット
ch3_offset = paradt(5,2);   %ch3のオフセット
ch4_offset = paradt(6,2);   %ch4のオフセット
ch1_max = paradt(7,2);      %ch1の最大値
ch2_max = paradt(8,2);      %ch2の最大値
ch3_max = paradt(9,2);      %ch3の最大値
ch4_max = paradt(10,2);     %ch4の最大値
f = t / t_max * fs;         %周波数
deg = 2;                    %フィルタの次数
fc_low = 1.5;               %バンドパスフィルタの低域カットオフ周波数
fc_high = 100;              %バンドパスフィルタの高域カットオフ周波数
fc_low2 = 1;                %ローパスフィルタのカットオフ周波数


%測定データのグラフ出力
figure;
subplot(2,2,1);
plot(t,ch1);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
xlabel('Time t[s]');
title('CH4');
sgtitle('測定データ');

%バンドパス(1.5～100Hz)
[b,a] = butter(deg,[fc_low fc_high]/(fs/2),'bandpass');
ch1 = filter(b,a,ch1);
ch2 = filter(b,a,ch2);
ch3 = filter(b,a,ch3);
ch4 = filter(b,a,ch4);
figure;
subplot(2,2,1);
plot(t,ch1);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
xlabel('Time t[s]');
title('CH4');
sgtitle('バンドパス(1.5～100Hz)');

%全波整流
ch1 = abs(ch1);
ch2 = abs(ch2);
ch3 = abs(ch3);
ch4 = abs(ch4);

figure;
subplot(2,2,1);
plot(t,ch1);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
xlabel('Time t[s]');
title('CH4');
sgtitle('全波整流');

%ローパス(1Hz)
[b, a] = butter(deg, fc_low2/(fs/2));
ch1 = filter(b,a,ch1);
ch2 = filter(b,a,ch2);
ch3 = filter(b,a,ch3);
ch4 = filter(b,a,ch4);
figure;
subplot(2,2,1);
plot(t,ch1);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
xlabel('Time t[s]');
title('CH4');
sgtitle('ローパス(1Hz)');

%オフセット除去
ch1 = ch1 - ch1_offset;
ch2 = ch2 - ch2_offset;
ch3 = ch3 - ch3_offset;
ch4 = ch4 - ch4_offset;
%負になったデータは0にする
for i = 1:dtsize
    if ch1(i) < 0
        ch1(i) = 0;
    end
    if ch2(i) < 0
        ch2(i) = 0;
    end
    if ch3(i) < 0
        ch3(i) = 0;
    end
    if ch4(i) < 0
        ch4(i) = 0;
    end
end

figure;
subplot(2,2,1);
plot(t,ch1);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH4');
sgtitle('オフセット除去');

%正規化
ch1 = ch1 / ch1_max;
ch2 = ch2 / ch2_max;
ch3 = ch3 / ch3_max;
ch4 = ch4 / ch4_max;
%1を超えたデータは1にする
for i = 1:dtsize
    if ch1(i) > 1
        ch1(i) = 1;
    end
    if ch2(i) > 1
        ch2(i) = 1;
    end
    if ch3(i) > 1
        ch3(i) = 1;
    end
    if ch4(i) > 1
        ch4(i) = 1;
    end
end

figure;
subplot(2,2,1);
plot(t,ch1);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH4');
sgtitle('正規化');

%各時間におけるチャンネルの総和を1に調整
for i = 1:dtsize
    sum = ch1(i) + ch2(i) + ch3(i) + ch4(i);
    ch1(i) = ch1(i) / sum;
    ch2(i) = ch2(i) / sum;
    ch3(i) = ch3(i) / sum;
    ch4(i) = ch4(i) / sum;
end

figure;
subplot(2,2,1);
plot(t,ch1);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH1');
subplot(2,2,2);
plot(t,ch2);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH2');
subplot(2,2,3);
plot(t,ch3);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH3');
subplot(2,2,4);
plot(t,ch4);
ylim([0,Inf]);
xlabel('Time t[s]');
title('CH4');
sgtitle('各時間における総和を1に調整');
