clear all, close all, clc

%% load data
load flutter.dat;
u = flutter(:, 1);
y = flutter(:, 2);

%% 1 rzad

close all, clc;

yN = y(2:end);
Phi = [y(1:end-1), u(1:end-1)];
theta = (Phi'*Phi)^-1 * Phi'*yN;

% Predykcja
preY = Phi * theta;


% szcowanie modelu
a = theta(1);
b = theta(2);
dend = [1, a(1)];
numd = [b(1)];
sys = tf(numd,dend,1);
[yTr] = lsim(sys,u);


% błedy
Bpre = yN - preY; % blad predykcji
Btrans = y - yTr; % bład modelu


%bład predykcji
VN = (yN- Phi* theta)' * (yN - Phi * theta);


% Odpowiedź skokowa i impulsowa
h = impulse(sys);
g = step(sys);

% porównanie wykresu z pobranych dany i stworzonej tranmitancji
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(y);
hold on;
plot(yTr);
hold off;
title('Porownianie szcowanym modelem');
legend("y","model");

% Porownanie z predykcja
subplot(2,1,2); 
plot(y);
hold on;
plot(preY);
hold off;
title('Porownanie z predykcja');
legend("y","Predykcja")


% Wykresy bledow
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(Bpre);
title('Błąd predykcji');
legend("Bład predykcji");

% Porownanie z predykcja
subplot(2,1,2); 
plot(Btrans);
title('Błąd z modelu');
legend("Błąd z modelu")


% Wykresy odpowiedzi skokowej i impulsowej
figure;
subplot(2,1,1); 
plot(h);
title('Impulse');
legend("h");

subplot(2,1,2);
plot(g);
title('step');
legend("g");


%% 2 rzad

close all, clc;

yN = y(3:end); % wektor danych wyjsciowych

Phi = [-y(2:end-1), -y(1:end-2), u(2:end-1), u(1:end-2)]; % macierz regresji
theta = (Phi' * Phi)^-1 * Phi' * yN; % wektor parametrów

% Predykcja
preY = Phi * theta;


% szacowanie transmitancji
a = theta(1:2);
b = theta(3:4);
dend = [1, a(1), a(2)];
numd = [b(1), b(2)];
sys = tf(numd,dend,1);
[yTr] = lsim(sys,u);


% błedy
Bpre = yN - preY; % blad predykcji
Btrans = y - yTr; % bład modelu


%bład predykcji
VN = (yN- Phi* theta)' * (yN - Phi * theta);


% Odpowiedź skokowa i impulsowa
h = impulse(sys);
g = step(sys);


% porównanie wykresu z pobranych dany i stworzonej tranmitancji
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(y);
hold on;
plot(yTr);
hold off;
title('Porownianie szcowanym modelem');
legend("y","model");

% Porownanie z predykcja
subplot(2,1,2); 
plot(y);
hold on;
plot(preY);
hold off;
title('Porownanie z predykcja');
legend("y","Predykcja")


% Wykresy bledow
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(Bpre);
title('Błąd predykcji');
legend("Bład predykcji");

% Porownanie z predykcja
subplot(2,1,2); 
plot(Btrans);
title('Błąd z modelu');
legend("Błąd z modelu")


% Wykresy odpowiedzi skokowej i impulsowej
figure;
subplot(2,1,1); 
plot(h);
title('Impulse');
legend("h");

subplot(2,1,2);
plot(g);
title('step');
legend("g");


%% Założenie nadmiarowego rzedu B

close all, clc;

yN = y(3:end);
Phi = [-y(2:end-1), -y(1:end-2), u(3:end),u(2:end-1), u(1:end-2)];
theta = (Phi' * Phi)^-1 * Phi' * yN;


% Predykcja
preY = Phi * theta;


% Szczowanie modelu
a = theta(1:2);
b = theta(3:5);
dend = [1, a(1), a(2)];
numd = [b(1), b(2), b(3)];
sys = tf(numd,dend,1);
[yTr] = lsim(sys,u);


% błedy
Bpre = yN - preY; % blad predykcji
Btrans = y - yTr; % bład modelu


%bład predykcji
VN = (yN- Phi* theta)' * (yN - Phi * theta)


% Odpowiedź skokowa i impulsowa
h = impulse(sys);
g = step(sys);


% porównanie wykresu z pobranych dany i stworzonej tranmitancji
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(y);
hold on;
plot(yTr);
hold off;
title('Porownianie szcowanym modelem');
legend("y","model");

% Porownanie z predykcja
subplot(2,1,2); 
plot(y);
hold on;
plot(preY);
hold off;
title('Porownanie z predykcja');
legend("y","Predykcja")


% Wykresy bledow
figure;

% Porownianie z transmitancja
subplot(2,1,1); 
plot(Bpre);
title('Błąd predykcji');
legend("Bład predykcji");

% Porownanie z predykcja
subplot(2,1,2); 
plot(Btrans);
title('Błąd z modelu');
legend("Błąd z modelu")


% Wykresy odpowiedzi skokowej i impulsowej

figure;
subplot(2,1,1); 
plot(h);
title('Impulse');
legend("h");

subplot(2,1,2); 
plot(g);
title('step');
legend("g");

