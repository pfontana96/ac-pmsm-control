% Control de un Accionamiento de CA con PMSM
clear; clc;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%           PARAMETROS SUBSISTEMA MECANICO
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% -------------------------
% Parametros carga mecanica
% -------------------------
% Parametros nominales -> (valor nominal +- variacion max)
J_l = 0.2520; % [kg.m2]
dJ_l = 0.1260; % [kg.m2]
b_l = 0; % [N.m.s/rad]
db_l = 0.0630; % [N.m.s/rad]
% T_l = T_l +- dT_l
T_l = 0; % Torque de Carga [N.m] asumir step
dT_l = 6.28; % Valor limite requerido
% -------------------------
% Parametros transmision
% -------------------------
r = 314.3008; % Relacion de transmision r:1
wl_nom = 2.2; % rad/s
Tq_nom = 7.26; % Torque nominal de salida [N.m]
Tq_max = 29.42; % Torque maximo de salida [N.m]

% ----------------------------
% Parametros maquina electrica
% ----------------------------
J_m = 3.1e-6; % [kg.m2]
b_m = 1.5e-5; % [N.m.s/rad]
P_p = 3; % Pares de polos magneticos (6 polos)
lambda_m = 0.01546; % Flujo magnetico eq de imanes [V.s/rad]
L_q = 5.8e-3; % Inductancia estator eje en cuadratura [H]
L_d = 6.6e-3; % Inductancia estator eje directo [H]
L_ls = 0.8e-3; % Inductancia de dispersion [H]

% ----------------------------
% Parametros equivalentes
% ----------------------------
J_eq = J_m + J_l/r^2; % Momento de inercia equivalente [kg.m2]
b_eq = b_m + b_l/r^2; % Amortiguamiento viscoso equivalente [N.m.s/rad]

% ----------------------------
% Parametros termicos
% ----------------------------
C_ts = 0.818; % Capacitancia termica de estator [W.s/°C]
R_ts_amb = 146.7; % Resistencia termica estator - ambiente [°C/W]
R_s_40 = 1.02; % Resistencia estator a 40°C [ohm]
R_s_115 = 1.32; % Resistencia estator a 115°C [ohm]
alpha_cu = 3.9e-3; % Coef aumento Rs con Ts(t) [1/°C]

% --------------------------------------------------
% Parametros promedio para sistema LTI simplificado
% --------------------------------------------------
R_s_prom = (1.32 - 1.02)/2; % Promedio resistencias dato (a 40°C y 115°C)

% --------------------------------------------------
% Parametros Modulador de torque - Control esclavo
% --------------------------------------------------
polo = -5000; % [rad/s]
R_q = -polo*L_q; % [ohm]
R_d = -polo*L_d; % [ohm]
R_0 = -polo*L_ls; % [ohm]

% --------------------------------------------------
% Parametros Controlador PID - Control maestro
% --------------------------------------------------
w_pos = 800; % [rad/s]
n = 2.5;

K_d = J_eq*n*w_pos;
K_p = J_eq*n*w_pos^2;
K_i = J_eq*w_pos^3;

% --------------------------------------------------
% Parametros de Observador
% --------------------------------------------------
obs_p = -3200; % [rad/s]
Ke_theta = -2*obs_p;
Ke_w = obs_p^2;