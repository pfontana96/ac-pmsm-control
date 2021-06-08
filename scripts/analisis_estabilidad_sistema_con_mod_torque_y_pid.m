clear; clc;
parametros_de_sistema;

% Valores maximos
J_eq_max = J_m + (J_l+dJ_l)/r^2;

% Valores minimos
J_eq_min = J_m + (J_l-dJ_l)/r^2;

syms s;

% Análisis de planta original


% Análisis del modulador de torque
tf_mod = tf(1, [L_q/R_q 1]);

% Análisis del controlador
tf_nom = tf(1, [J_eq K_d K_p K_i]);
tf_min = tf(1, [J_eq_min K_d K_p K_i]);
tf_max = tf(1, [J_eq_max K_d K_p K_i]);

figure(1);
pzmap(tf_mod*tf_min, 'g', tf_mod*tf_nom, 'b', tf_mod*tf_max, 'r');
hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
hm(2).LineWidth = 2;                      % ‘Zero’ Marker
hm(3).LineWidth = 2;                      % ‘Pole’ Marker
hm(4).LineWidth = 2;                      % ‘Zero’ Marker
hm(5).LineWidth = 2;                      % ‘Pole’ Marker
hm(6).LineWidth = 2;                      % ‘Zero’ Marker
hm(7).LineWidth = 2;                      % ‘Pole’ Marker
grid on;
legend('Mínimos', 'Nominales', 'Máximos');