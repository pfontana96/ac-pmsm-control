clear;clc;close all;
parametros_de_sistema;
% Sistema LPV
% Punto de operacion
wm_op = 691.15; % [rad/s]
iqs_op = 0.4;   % [A]
i0s_op = 0;     % [A]
Ts_op = 115;    % [°C]

R_s = R_s_115; % Para 115 °C


syms ids_op
A = [0 1                                    0                                             0                                   0 0;
     0 -b_eq/J_eq                           (3*P_p/(2*J_eq))*(lambda_m+(L_d-L_q))*ids_op (3*P_p/(2*J_eq))*(L_d - L_q)*iqs_op  0 0;
     0 -(P_p/L_q)*(lambda_m + L_d*ids_op)  -R_s/L_q                                      -(L_d/L_q)*P_p*wm_op                 0 0;
     0 (L_q/L_d)*P_p*iqs_op                 (L_q/L_d)*P_p*wm_op                          -R_s/L_d                             0 0;
     0 0                                    0                                            0                                    -R_s/L_ls 0;
     0 0                                    3*iqs_op*R_s/C_ts                            3*ids_op*R_s/C_ts                    6*i0s_op*R_s/C_ts -1/(R_ts_amb*C_ts)];         

 for ids_i = -2:0.01:2
    A_i = double(subs(A, ids_op, ids_i));
    values = vpa(eig(A_i), 4);
    fprintf("Para ids_op = %f\nAutovalores:", ids_i);
    disp(values);
 end