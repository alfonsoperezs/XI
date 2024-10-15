%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%

clear all;
close all;

%=================== Parametros ==================================

N=20;		 % Periodo de simbolo
L=6;		 % Numero de bits a transmitir
tipopulso=2; %1: pulso rectangular

%=================== Generacion del pulso =========================

if tipopulso == 1  % pulso rectangular
  n=0:N-1;
  pulso=ones(1,N);
elseif tipopulso == 2 % p(n) = u(n) − u(n − N/2)
  n=0:N-1;
  pulso = [ones(1, N/2), zeros(1, N - N/2)];
elseif tipopulso == 3 % p(n) = u(n) − 2u(n − N/2) + u(n − N) pulso de manchester
  n=0:N-1;
  pulso = [ones(1, N/2), -ones(1, N - N/2)];
elseif tipopulso == 4 %pulso rampa
    n = 0:N-1;
    pulso = linspace(0, 1, N);
end;

%=================== Calculo de la energia del pulso =============

Eb=sum(abs(pulso).^2) % energia de bit -> duracion del pulso = N

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a un bit 0 y
%un pulso con amplitud negativa a un bit 1
s_mod = [];  % Inicializar la señal modulada como un vector vacío
for k=1:L
    Ak= 1-2*bits(k);
    s_mod=[s_mod,pulso*Ak]; %concatenacion do pulso e señal
end

%=================== Generación de señal recibida  =============

%Escriba el codigo para obtener la señal recibida (transmitida + ruido)
EbNo = 3;

EbNo=10^(EbNo/10);
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L);

srec = s_mod + ruido

%=================== Calculo de la probabilidad de error ===========

%Escriba el codigo para calcular la probabilidad de error teórica y real
pulsoinv = pulso(N:-1:1);
ind = 1;
for k = 1:N:L*N-1
    s_conv = conv(srec(k:k+N-1),pulsoinv);
    s_muest = s_conv(N);
    bits_rec(ind) = s_muest <= 0;
    ind = ind + 1;
end;
pe_real = mean(bits_rec ~= bits);
pe_teo = erfc(sqrt(EbNo))/2;

%=================== Representacion grafica ===================

figure(1)
plot(n,pulso);
axis([0 N -2 2])
xlabel('t(s)')
ylabel('Valor')
title('Pulso transmitido: p(n)');
grid;

figure(2)
stem(n,pulso);
axis([0 N -2 2])
xlabel('t(s)')
ylabel('Valor')
title('Pulso transmitido: p(n)');
grid;

figure(3)  
subplot(211)
plot(s_mod, 'b'); 
hold on;  
grid;
title('Señal modulada e transmitida');
axis([0 10*N -2 2]);

subplot(212)
hold on;
plot(0:( (N*L)-1 ), srec, 'r');
plot(0:( (N*L)-1 ), s_mod);
axis([0 10*N -2 2]);
title('Señal recibida');