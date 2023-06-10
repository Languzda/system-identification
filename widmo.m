clear;
close all;
clc;

% Załadowanie oraz wybranie kluczowych do identyfikacji danych
load('flutter.dat');

% Okres próbkowania odczytany
Tp = 0.5;

% Pomiar wejścia do obiektu
u = flutter(:, 1);
% Pomiar wyjścia z obiektu
y = flutter(:, 2);

dataSize = size(y);
% Ilość próbek
N = dataSize(1);

%% Analiza widmowa
k = 0:N-1;
F = 2*pi/(N*Tp)*k;
G = fft(y)./fft(u);
Lm = 20*log10(abs(G));
fi = atan2(imag(G), real(G));

figure;
subplot(2,1,1);
semilogx(F, Lm);
title('Lm');
subplot(2,1,2); 
semilogx(F, fi);
title('fi');

%% Obliczenie korelacji
Ryu = xcorr(y,u);
Ruy = xcorr(u,y);
Ruu = xcorr(u,u);

% Stworzenie okna Hanninga
Mw = 200;
Hn = hann(2*Mw+1);
Hn_pad = [zeros((2*N-2*Mw-2)/2, 1); Hn; zeros((2*N-2*Mw-2)/2, 1)];

% Wartości korelacji pomnożone przez okno Hanninga
Ryu_hanning = Ryu .* Hn_pad;
Ruy_hanning = Ruy .* Hn_pad;
Ruu_hanning = Ruu .* Hn_pad;

% Wyodrębnienie odpowiednich fragmentów korelacji
Ryu_hanning = Ryu_hanning(N:end);
Ruy_hanning = Ruy_hanning(N:end);
Ruu_hanning = Ruu_hanning(N:end);

% Dodanie odpowiednich wartości zerowych w celu zachowania długości N
Ruu_hanning = [Ruu_hanning(1:Mw+1); zeros(N-2*Mw-1, 1); Ruu_hanning(Mw+1:-1:2)];
Ryu_hanning = [Ryu_hanning(1:Mw+1); zeros(N-2*Mw-1, 1); Ruy_hanning(Mw+1:-1:2)];

% Obliczenie transformaty Fouriera
G_hanning = fft(Ryu_hanning) ./ fft(Ruu_hanning);

% Wykresy dla okna Hanninga
figure;
Lm_hanning = 20*log10(abs(G_hanning));
fi_hanning = atan2(imag(G_hanning), real(G_hanning));

subplot(2,1,1);
semilogx(F, Lm_hanning);
title('Lm - Okno Hanninga');
subplot(2,1,2);
semilogx(F, fi_hanning);
title('fi - Okno Hanninga');

% Obliczenie korelacji z oknem prostokątnym
Ryu_rect = xcorr(y,u);
Ruy_rect = xcorr(u,y);
Ruu_rect = xcorr(u,u);

% Wyodrębnienie odpowiednich fragmentów korelacji
Ryu_rect = Ryu_rect(N:end);
Ruy_rect = Ruy_rect(N:end);
Ruu_rect = Ruu_rect(N:end);

% Dodanie odpowiednich wartości zerowych w celu zachowania długości N
Ruu_rect = [Ruu_rect(1:Mw+1); zeros(N-2*Mw-1, 1); Ruu_rect(Mw+1:-1:2)];
Ryu_rect = [Ryu_rect(1:Mw+1); zeros(N-2*Mw-1, 1); Ruy_rect(Mw+1:-1:2)];

% Obliczenie transformaty Fouriera
G_rect = fft(Ryu_rect) ./ fft(Ruu_rect);

% Wykresy dla okna prostokątnego
figure;
Lm_rect = 20*log10(abs(G_rect));
fi_rect = atan2(imag(G_rect), real(G_rect));

subplot(2,1,1);
semilogx(F, Lm_rect);
title('Lm - Okno Prostokątne');
subplot(2,1,2);
semilogx(F, fi_rect);
title('fi - Okno Prostokątne');
