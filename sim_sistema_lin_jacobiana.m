% Linealizacion Jacobiana de sistema NL completo

% Invocacion script de parametros
parametros_de_sistema;

% Creacion matrices del sistema linearizado:
% dX/dt = A*dX + B*dU
% y = C*dX
% Donde A = [df/dx1 ... df/dxn]
%       B = [df/du1 ... df/dum]
%       C = [1 0 ... 0]
syms w_m_op iqs_op ids_op;


A = [0 0 0 0 0 0
     1 -b_eq/J_eq -P_p*(lambda_m+L_d*ids_op)/J_eq L_q*P_p*iqs_op/L_d 0 0
     0 (3*P_p/(2*J_eq))*(1 + (L_d-L_q))*ids_op -R_s_40]; 
%A = [0, 0, 0, 0, 0, 0; 1, -b_eq/J_eq], -P_p*(lambda_m + L_d*ids_op)/J_eq, L_q*P_p*w_m_op/L_d, 0, 0];