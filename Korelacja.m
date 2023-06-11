clear;
close all;

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

t = 0:Tp:(N-1)*Tp;

%% Analiza korelacyjna
ryu = xcorr(y, u, 'biased');
ryu = ryu(N:end);

M = 200;

ruu = xcorr(u, u, 'biased');
ryu = ryu(1:M);

Ruu = toeplitz(ruu(N:N+M-1));

g2 = pinv(Ruu) * ryu; % pinv - pseudoodwrotność

t_g = 0:Tp:(M-1)*Tp;

figure;
plot(t_g, g2);
hold on;
plot(t_g, [0; g2(1:M-1)]);
legend('g(t)', 'g(t) - przesunięty');
title("Impulsowa");
xlabel('t');
ylabel('y');

% Odpowiedź na inne wymuszenie
h = zeros(M, 1);

for i = 1:M
    h(i) = Tp * sum(g2(1:i));
end

figure;
plot(t_g, h);
hold on;
plot(t_g, [0; h(1:M-1)]);
legend('h(t)', 'h(t) - przesunięty');
title("Skokowa");
xlabel('t');
ylabel('y');