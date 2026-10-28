clear all % apaga variáveis e os gráficos
close all

L = 0.41;                       % (m) comprimento do propelente
g = 9.8;                       % (m/s^2), gravidade
Mf = 50;                       % (kg) Massa final
DRef = 0.122;                  % (m) diâmetro do foguete
SRef = pi*DRef^2/4;            % (m^2) area de referência
Vq = 0.0125;                    % (m/s) velocidade de queima do propelente
RhoProp = 1540;                % (kg/m^3) densidade do propelente
PhiE = DRef - 0.002;           % (m) Diâmetro externo do propelente
PhiI = 0.3*PhiE;               % (m) Diâmetro interno do propelente
Isp = 230;                     % (s) Impulso especifíco   

Tq = (PhiE - PhiI)/(2*Vq);     % (s) Tempo de queima
Vol = (pi/4)*(PhiE^2 - PhiI^2)*L     % (m^3) Volume do propelente
MProp = RhoProp*Vol;           % (kg) massa do propelente

% Cálculo do empuxo
F = Isp*MProp*g/Tq

% Movimento na rampa (desprezando arrasto e variação de massa, mas é uma aproximação válida!!)
LRampa = 2;                    % (m) comprimento da rampa
Acel = F/(Mf + MProp);         % (m/s^2) aceleracao na rampa  
V0 = sqrt(2*Acel*LRampa);      % (m/s) velocidade na saida da rampa
TRampa = V0/Acel;              % (s) Tempo na rampa

% Massa na saída da rampa
MProp0 = MProp*(Tq - TRampa)/Tq;     % (kg) Massa que sobra ao sair da rampa, diferença bem pequena

%Tempo de queima após a saída da rampa
Tqf = Tq - TRampa;

% Tabela de propulsão
% TabProp = [ tempo        empuxo   mprop ]
TabProp =   [   0            F     MProp0 ; ...
    Tqf          F     0;       ...
    Tqf + 0.01   0     0];
% Arrasto
% VCd = [ Mach   Cd ]
VCd   = [  0    0.33; ...
    0.7  0.33; ...
    0.9  0.42; ...
    1.1  0.67; ...
    1.2  0.68; ...
    1.5  0.7];

% Condições iniciais
Gamma0 = 89*pi/180            % (rad) angulo da rampa
x0 = LRampa*cos(Gamma0);      % (m) posição x do foguete na saída da rampa
h0 = LRampa*sin(Gamma0);
M0 = Mf + MProp0;

% F = 4.25e3
% MProp = 6.33
% MProp0 = 5.9
% Tq = 3.36
% V0 = 17.3
% M0 = 55.9

S = sim('voo.slx');

% Plota os resultados
figure
plot(S.h.time,S.h.Data);
xlabel('t (s)');
ylabel('v (m/s)');
grid on

figure
plot(S.v.time,S.v.Data);
xlabel('t (s)');
ylabel('v (m/s)');
grid on

figure
plot(S.Gamma.time, S.Gamma.Data*180/pi);
xlabel('t (s)');
ylabel('gama (graus)');
grid on

figure
plot(S.x.Data, S.h.Data);
axis('equal');
xlabel('x (m)');
ylabel('h (m)');
grid on

disp(['hmax = ' num2str(max(S.h.Data)) ' m']);

