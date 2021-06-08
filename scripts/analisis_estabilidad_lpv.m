clear;clc;close all;
parametros_de_sistema;
% Sistema LPV
% Selección de variable a evaluar
evaluate = "ids";
% evaluate = "w_m";
% evaluate = "T_s";

% Punto de operacion
wm_op = 691.15; % [rad/s]
iqs_op = 0.4;   % [A]
ids_op = 0;   % [A]
i0s_op = 0;     % [A]
Ts_op = 115;    % [°C]

R_s = R_s_115; % Para 115 °C

if evaluate=="ids"
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
        fprintf("Para ids_op = %f A\nAutovalores:", ids_i);
        disp(values);
     end
else if evaluate == "T_s"
    syms R_s
    A = [0 1                                    0                                             0                                   0 0;
         0 -b_eq/J_eq                           (3*P_p/(2*J_eq))*(lambda_m+(L_d-L_q))*ids_op (3*P_p/(2*J_eq))*(L_d - L_q)*iqs_op  0 0;
         0 -(P_p/L_q)*(lambda_m + L_d*ids_op)  -R_s/L_q                                      -(L_d/L_q)*P_p*wm_op                 0 0;
         0 (L_q/L_d)*P_p*iqs_op                 (L_q/L_d)*P_p*wm_op                          -R_s/L_d                             0 0;
         0 0                                    0                                            0                                    -R_s/L_ls 0;
         0 0                                    3*iqs_op*R_s/C_ts                            3*ids_op*R_s/C_ts                    6*i0s_op*R_s/C_ts -1/(R_ts_amb*C_ts)];         

     for T_i = 0:1:115
        R_si = R_s_40*(1 + alpha_cu*(T_i - 40));
        A_i = double(subs(A, R_s, R_si));
        values = vpa(eig(A_i), 4);
        fprintf("Para T_i = %f °C\nAutovalores:", T_i);
        disp(values);
     end
    else if evaluate == "w_m"
        syms wm_op
        A = [0 1                                    0                                             0                                   0 0;
             0 -b_eq/J_eq                           (3*P_p/(2*J_eq))*(lambda_m+(L_d-L_q))*ids_op (3*P_p/(2*J_eq))*(L_d - L_q)*iqs_op  0 0;
             0 -(P_p/L_q)*(lambda_m + L_d*ids_op)  -R_s/L_q                                      -(L_d/L_q)*P_p*wm_op                 0 0;
             0 (L_q/L_d)*P_p*iqs_op                 (L_q/L_d)*P_p*wm_op                          -R_s/L_d                             0 0;
             0 0                                    0                                            0                                    -R_s/L_ls 0;
             0 0                                    3*iqs_op*R_s/C_ts                            3*ids_op*R_s/C_ts                    6*i0s_op*R_s/C_ts -1/(R_ts_amb*C_ts)];         

         for wm_i = 0:2:691
            A_i = double(subs(A, wm_op, wm_i));
            values = vpa(eig(A_i), 4);
            fprintf("Para wm = %f rad/s\nAutovalores:", wm_i);
            disp(values);
         end
        end
    end
end