clear; clc;
% Calculos funciones de transferencia para sistema LTI simplificado
syms b_eq J_eq P_p lambda_m L_q R_s r s L_d;
A = [0 1                 0 
     0 -b_eq/J_eq        3*P_p*lambda_m/(2*J_eq)
     0 -P_p*lambda_m/L_q -R_s/L_q];
B = [ 0     0           0
      0     -1/(J_eq*r) 0
      1/L_q 0           0];
C = [1 0 0];
D = [0 0 0];

sys_tf = (C/(s*eye(3)-A))*B + D;
disp("==== ESTABILIDAD - funciones de transferencia del sistema");
disp("OMEGA(S)/V_Q(s):");
disp(sys_tf(1));
disp("OMEGA(S)/T_L(s):");
disp(sys_tf(2));
% simplify(sys_tf)
%=================================================
%                Estabilidad
%=================================================
disp("==== ESTABILIDAD - polos del sistema");
poles = simplify(poles(sys_tf(1)));
disp(poles);

disp("==== ESTABILIDAD - ceros del sistema");
% Zros para transferencia OMEGA(s)/V_D(s)
disp("Ceros OMEGA(s)/V_D(s):");
[num, ~] = numden(sys_tf(1));
eqn = num == 0;
zeros = simplify(solve(eqn, s));
disp(zeros);

% Zros para transferencia OMEGA(s)/T_L(s)
disp("Ceros OMEGA(s)/T_L(s):");
[num, ~] = numden(sys_tf(2));
eqn = num == 0;
zeros = simplify(solve(eqn, s));
disp(zeros);

%=================================================
%                Observabilidad
%=================================================
disp("==== OBSERVABILIDAD - para theta_m")
C =  [1 0 0]; % theta_m
O_ = [C
      C*A
      C*(A*A)]
fprintf('Rango de observabilidad: %d -> es observable desde la salida theta_m',rank(O_));

disp("==== OBSERVABILIDAD - para w_m")
C =  [0 1 0]; % w_m
O_ = [C
      C*A
      C*(A*A)]
fprintf('Rango de observabilidad: %d -> NO es observable desde la salida w_m',rank(O_));

disp("==== OBSERVABILIDAD - para i_q")
C =  [0 0 1]; % i_q
O_ = [C
      C*A
      C*(A*A)]
fprintf('Rango de observabilidad: %d -> NO es observable desde la salida i_q\n',rank(O_));

disp('Modelo LTI AUMENTADO -> dinamica residual del eje d, que agrega i_d que no tiene entrada')
A_aum = [[A(:,1);0] [A(:,2);0] [A(:,3);0] [0;0;0;-R_s/L_d]];
C =  [1 0 0]; % theta_m
O_ = [C
      C*A
      C*(A*A)]
fprintf('Rango de observabilidad: %d -> es observable desde la salida theta_m',rank(O_));  
%=================================================
%                Controlabilidad
%=================================================
disp("==== CONTROLABILIDAD ====")
B_aux = B(:,1);  % La entrada T_l es una perturbacion (no se puede controlar). Usamos solo la tension v_q
C_ = [B_aux,A*B_aux,(A*A)*B_aux]
fprintf('Rango de controlabilidad: %d -> el modelo LTI SIMPLIFICADO es controlable desde v_q\n\n',rank(C_));
disp('Modelo LTI AUMENTADO -> dinamica residual del eje d, que agrega i_d que no tiene entrada')
disp(' => sistema NO es totalmente controlable desde v_q')
disp(' ==> se agrega una entrada al eje d')
B_aum = [[B(:,1);0] [0; 0; 0; 1/L_d]];
A_aum = [[A(:,1);0] [A(:,2);0] [A(:,3);0] [0;0;0;-R_s/L_d]];
C_ = [B_aum, A_aum*B_aum, (A_aum*A_aum)*B_aum]
fprintf('Rango de controlabilidad: %d -> el modelo LTI AUMENTADO es controlable desde v_q y v_d',rank(C_));
 