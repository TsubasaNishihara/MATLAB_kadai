clear
n=4096;         %�f�[�^��
dt=0.005;       %�T���v�����O�Ԋu
t=((1:n)-1)*dt;
f=t/dt/dt/n;    
fs=1/dt;        %�T���v�����O���g��
fc_high = 10;   %�n�C�p�X�p
fc_low = 70;    %���[�p�X�p

%�Ւf���g����T���v�����Ȃǂ͏�̂��̂��g���Ă�������

%sin�g�̍쐬�ƍ����g�̍쐬
y = 0.5*sin(2*pi*5*t) + sin(2*pi*50*t) + 0.8*sin(2*pi*80*t);

figure;
subplot(4,3,1);
plot(t, y);
xlim([0 0.3]);
xlabel('Time t[s]');
title('�����g');

y2 = fft(y);
y_abs = abs(y2);
subplot(4,3,2);
plot(f, y_abs);
xlabel('Frequency f[Hz]');
title('FFT');

%�t�B���^�[�̍쐬�ƓK�p(�O���t���쐬).
%�t�B���^�̎�����2�ł��܂���.
%���[�p�X
[b, a] = butter(2, fc_low/(fs/2));
y_fil1 = filter(b, a, y);
y_fft = fft(y_fil1);
y_abs1 = abs(y_fft);

%�n�C�p�X
[b, a] = butter(2, fc_high/(fs/2), 'high');
y_fil2 = filter(b, a, y);
y_fft = fft(y_fil2);
y_abs2 = abs(y_fft);

%�o���h�p�X
[b, a] = butter(2, [fc_high fc_low]/(fs/2), 'bandpass');
y_fil3 = filter(b, a, y);
y_fft = fft(y_fil3);
y_abs3 = abs(y_fft);

subplot(4,3,4);
plot(t, y_fil1);
xlabel('Time t[s]');
title('���[�p�X');
xlim([0 0.3]);

subplot(4,3,5);
plot(t, y_fil2);
xlabel('Time t[s]');
title('�n�C�p�X');
xlim([0 0.3]);

subplot(4,3,6);
plot(t, y_fil3);
xlabel('Time t[s]');
title('�o���h�p�X');
xlim([0 0.3]);


subplot(4,3,7);
plot(f, y_abs1);
xlabel('Frequency f[Hz]');
title('���[�p�X');

subplot(4,3,8);
plot(f, y_abs2);
xlabel('Frequency f[Hz]');
title('�n�C�p�X');

subplot(4,3,9);
plot(f, y_abs3);
xlabel('Frequency f[Hz]');
title('�o���h�p�X');

% �_�E���T���v�����O�i�T���v���������炷�j
dt2 = 0.0005;
t=((1:n)-1)*dt2; 
y = 0.5*sin(2*pi*5*t) + sin(2*pi*50*t) + 0.8*sin(2*pi*80*t);
subplot(4,3,10);
stem(t, y, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('���M��');

y_down = downsample(y,3);
t_down = downsample(t,3);
subplot(4,3,11);
stem(t_down, y_down, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('�_�E���T���v�����O���ꂽ�M��');


% �A�b�v�T���v�����O�F3���X�v���C����ԁi�T���v�����𑝂₷�j
y = spline(t_down,y_down,t);
subplot(4,3,12);
stem(t, y, '.');
xlim([0 0.05]);
xlabel('Time t[s]');
title('�A�b�v�T���v�����O���ꂽ�M��');
