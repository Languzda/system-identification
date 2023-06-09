clear all, close all, clc

%% load data
load flutter.dat;
u = flutter(:, 1); % pomiar sygnalu wymuszajacego
y = flutter(:, 2); % pomiar sygnału wyjsciowego

%% 1 rzad
clearPls();

yN = y(2:end); % wektor danych wyjsciowych
Phi = [y(1:end-1), u(1:end-1)]; % macierz regresji
theta = (Phi'*Phi)^-1 * Phi'*yN; % wektor parametrów

a = theta(1);
b = theta(2);

processAndPlotData(u, y, yN, Phi, theta, a, b)


%% 2 rzad
clearPls();

yN = y(3:end); % wektor danych wyjsciowych

Phi = [-y(2:end-1), -y(1:end-2), u(2:end-1), u(1:end-2)]; % macierz regresji
theta = (Phi' * Phi)^-1 * Phi' * yN; % wektor parametrów

a = theta(1:2);
b = theta(3:4);

processAndPlotData(u, y, yN, Phi, theta, a, b)


%% Założenie nadmiarowego rzedu B
clearPls();

yN = y(3:end); % wektor danych wyjsciowych
Phi = [-y(2:end-1), -y(1:end-2), u(3:end),u(2:end-1), u(1:end-2)]; % macierz regresji
theta = (Phi' * Phi)^-1 * Phi' * yN; % wektor parametrów

a = theta(1:2);
b = theta(3:5);

processAndPlotData(u, y, yN, Phi, theta, a, b)

%% MNK3

clearPls();
yN = y(4:end);
Phi = [y(3:end-1), y(2:end-2), y(1:end-3), u(3:end-1), u(2:end-2), u(1:end-3)];
theta = (Phi' * Phi)^-1 * Phi' * yN;


%Yr = Phi * theta
a = theta(1:3);
b = theta(4:6);

processAndPlotData(u, y, yN, Phi, theta, a, b)

%% funkcje
function plotComparison(y, yTr, preY, Bpre, Btrans, h, g)
    % Porownianie z transmitancja
    figure;
    subplot(2,1,1);
    plot(y);
    hold on;
    plot(yTr);
    hold off;
    title('Porownanie z szacowanym modelem');
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
    plot(g);
    title('Impulse');
    legend("g");

    subplot(2,1,2);
    plot(h);
    title('step');
    legend("h");
end

function processAndPlotData(u, y, yN, Phi, theta, a, b)
    % Predykcja
    preY = Phi * theta;

    startPoint = size(u) - size(yN);

    startPoint = startPoint(1) + 1 ;

    % Model
    dend = [1, a'];
    numd = [b'];
    sys = tf(numd, dend, 1);
    [yTr] = lsim(sys, u);

    % Błędy
    Bpre = yN - preY; % błąd predykcji
    Btrans = y - yTr; % błąd modelu

    % Błąd predykcji
    VN = (yN - Phi * theta)' * (yN - Phi * theta);

    figure;
    stem(u(startPoint:end),Bpre);
    title("korelacja błędu Epsilon")

    % Odpowiedź skokowa i impulsowa
    g = impulse(sys);
    h = step(sys);

    % Rysowanie wykresów
    plotComparison(y, yTr, preY, Bpre, Btrans, h, g);

     % Wydruk parametrów
    disp('Parametry:');
    disp('a:');
    disp(a);
    disp('b:');
    disp(b);
    disp('VN:');
    disp(VN);
    disp('Model:');
    sys
end

function clearPls()
    clear a b Phi yN theta;
    close all;
    clc;
end