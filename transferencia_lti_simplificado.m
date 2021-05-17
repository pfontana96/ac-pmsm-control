clear; clc;
% Calculos funciones de transferencia para sistema LTI simplificado
syms b_eq J_eq P_p lambda_m L_q R_s r s;
A = [0 1                 0 
     0 -b_eq/J_eq        3*P_p*lambda_m/(2*J_eq)
     0 -P_p*lambda_m/L_q -R_s/L_q];
B = [ 0     0           0
      0     -1/(J_eq*r) 0
      1/L_q 0           0];
C = [1 0 0];
D = [0 0 0];

sys_tf = (C/(s*eye(3)-A))*B + D;
sys_tf
simplify(sys_tf)