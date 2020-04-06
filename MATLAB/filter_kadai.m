clear
n=4096;         %データ数
dt=0.005;       %サンプリング間隔
t=((1:n)-1)*dt;
f=t/dt/dt/n;    
fs=1/dt;        %サンプリング周波数
fc_high = 10;   %ハイパス用
fc_low = 70;    %ローパス用

%遮断周波数やサンプル数などは上のものを使ってください

%sin波の作成と合成波の作成
y = 0.5*sin(2*pi*5*t) + sin(2*pi*50*t) + 0.8*sin(2*pi*80*t);

figure;
subplot(4,3,1);
plot(t, y);
xlim([0 0.3]);
xlabel('Time t[s]');
title('合成波');

y2 = fft(y);
y_abs = abs(y2);
subplot(4,3,2);
plot(f, y_abs);
xlabel('Frequency f[Hz]');
title('FFT');

%フィルターの作成と適用(グラフも作成).
%フィルタの次数は2でやりました.
%ローパス
[b, a] = butter(2, fc_low/(fs/2));
y_fil1 = filter(b, a, y);
y_fft = fft(y_fil1);
y_abs1 = abs(y_fft);

%ハイパス
[b, a] = butter(2, fc_high/(fs/2), 'high');
y_fil2 = filter(b, a, y);
y_fft = fft(y_fil2);
y_abs2 = abs(y_fft);

%バンドパス
[b, a] = butter(2, [fc_high fc_low]/(fs/2), 'bandpass');
y_fil3 = filter(b, a, y);
y_fft = fft(y_fil3);
y_abs3 = abs(y_fft);

subplot(4,3,4);
plot(t, y_fil1);
xlabel('Time t[s]');
title('ローパス');
xlim([0 0.3]);

subplot(4,3,5);
plot(t, y_fil2);
xlabel('Time t[s]');
title('ハイパス');
xlim([0 0.3]);

subplot(4,3,6);
plot(t, y_fil3);
xlabel('Time t[s]');
title('バンドパス');
xlim([0 0.3]);


subplot(4,3,7);
plot(f, y_abs1);
xlabel('Frequency f[Hz]');
title('ローパス');

subplot(4,3,8);
plot(f, y_abs2);
xlabel('Frequency f[Hz]');
title('ハイパス');

subplot(4,3,9);
plot(f, y_abs3);
xlabel('Frequency f[Hz]');
title('バンドパス');

% ダウンサンプリング（サンプル数を減らす）
dt2 = 0.0005;
t=((1:n)-1)*dt2; 
y = 0.5*sin(2*pi*5*t) + sin(2*pi*50*t) + 0.8*sin(2*pi*80*t);
subplot(4,3,10);
stem(t, y, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('原信号');

y_down = downsample(y,3);
t_down = downsample(t,3);
subplot(4,3,11);
stem(t_down, y_down, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('ダウンサンプリングされた信号');


% アップサンプリング：3次スプライン補間（サンプル数を増やす）
y = spline(t_down,y_down,t);
subplot(4,3,12);
stem(t, y, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('アップサンプリングされた信号');
