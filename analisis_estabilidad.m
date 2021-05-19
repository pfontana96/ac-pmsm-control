clear;clc;close all;

J_m = 3.1e-6; % [kg.m2]
b_m = 1.5e-5; % [N.m.s/rad]
J_l = 0.2520; % [kg.m2]
b_l = 0; % [N.m.s/rad]
r = 314.3008; % Relacion de transmision r:1
J_eq = J_m + J_l/r^2; % Momento de inercia equivalente [kg.m2]
b_eq = b_m + b_l/r^2; % Amortiguamiento viscoso equivalente [N.m.s/rad]
P_p = 3; % Pares de polos magneticos (6 polos)
lambda_m = 0.01546; % Flujo magnetico eq de imanes [V.s/rad]
L_q = 5.8e-3; % Inductancia estator eje en cuadratura [H]
R_s = 1.02;
% Funcion de transferencia
H = tf([L_q  R_s],[L_q*J_eq  b_eq*L_q+J_eq*R_s  b_eq*R_s+(3*P_p^2*lambda_m^2)/2  0])

% Calculo de polos de la funcion
p = pole(H)

% Calculo de zeros de la funcion
z = zero(H)

% Gr�fico de los polos y ceros
pzmap(H)
grid on

% Teniendo en cuenta las variaciones de J_l y b_l
dJ_l = 0.1260; % [kg.m2]
db_l = 0.0630; % [N.m.s/rad]

J_eq_max = J_m + (J_l+dJ_l)/r^2;
b_eq_max = b_m + (b_l+db_l)/r^2;
H_max = tf([L_q  R_s],[L_q*J_eq_max  b_eq_max*L_q+J_eq_max*R_s  b_eq_max*R_s+(3*P_p^2*lambda_m^2)/2  0]);
p_max = pole(H_max)
z_max = zero(H_max)

J_eq_min = J_m + (J_l-dJ_l)/r^2;
b_eq_min = b_m + (b_l-db_l)/r^2;
H_min = tf([L_q  R_s],[L_q*J_eq_min  b_eq_min*L_q+J_eq_min*R_s  b_eq_min*R_s+(3*P_p^2*lambda_m^2)/2  0]);
p_min = pole(H_min)
z_min = zero(H_min)

%pzmap(H,H_max,H_min)
%grid on

