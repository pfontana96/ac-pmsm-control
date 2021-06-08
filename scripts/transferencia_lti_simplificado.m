% Calculo de funciones de transferencia, analisis de estabilidad, analisis
% de observabilidad y controlabilidad
% 
% Modo de uso:
% Seleccionar 'evaluate' de acuerdo al sistema a analizar ("simplificado" o "aumentado")
% En caso de querer evaluar el sistema LTI AUMENTADO con vds(t) como una
% variable manipulada, setear el valor de 'agregar_vds' a 'true'


clear; clc;
% evaluate = "simplificado";
evaluate = "aumentado";
agregar_vds = false;

fprintf("ANALISIS PARA SISTEMA LTI %s\n-------------------------------------\n", evaluate);
syms b_eq J_eq P_p lambda_m L_q R_s r s L_d theta_m omega_m iqs ids vqs Tl vds;
if evaluate == "simplificado"
    % Calculos funciones de transferencia para sistema LTI simplificado
    x = [theta_m; omega_m; iqs];
    u = [vqs; Tl];
    
    A = [0 1                 0 
         0 -b_eq/J_eq        3*P_p*lambda_m/(2*J_eq)
         0 -P_p*lambda_m/L_q -R_s/L_q];
    B = [ 0     0          
          0     -1/(J_eq*r)
          1/L_q 0          ];
    C = [1 0 0];
    D = [0 0];
    
elseif evaluate == "aumentado"
    % Calculos funciones de transferencia para sistema LTI aumentado
    x = [theta_m; omega_m; iqs; ids];
    
    A = [0 1                 0                       0
         0 -b_eq/J_eq        3*P_p*lambda_m/(2*J_eq) 0
         0 -P_p*lambda_m/L_q -R_s/L_q                0
         0 0                 0                       -R_s/L_d];
    % Sin controlar sobre vds(t)
    u = [vqs; Tl];
    B = [ 0     0          
          0     -1/(J_eq*r)
          1/L_q 0          
          0     0];
    C = [1 0 0 0];
    D = [0 0];
    
    if agregar_vds
        % Controlando sobre vds(t)
        u = [vqs; vds; Tl];
        B = [ 0     0    0          
              0     0    -1/(J_eq*r)
              1/L_q 0    0          
              0     1/L_d    0];
        D = [0 0 0];
    end 
         
end
n = length(x);
sys_tf = (C/(s*eye(n)-A))*B + D;
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
zeros_ = simplify(solve(eqn, s));
disp(zeros_);

% Zros para transferencia OMEGA(s)/T_L(s)
disp("Ceros OMEGA(s)/T_L(s):");
[num, ~] = numden(sys_tf(2));
eqn = num == 0;
zeros_ = simplify(solve(eqn, s));
disp(zeros_);

%=================================================
%                Observabilidad
%=================================================
for i=1:n
    fprintf("~~~~~~~~~~~~~~~~~~~~~~\nAnalisis observabilidad para %s:\n", char(x(i)));
    C_temp = zeros(1, n);
    C_temp(i) = 1;
    
    O_ = observabilidad_kalman(A, C_temp);
    
    rango = rank(O_);
    if rango == n
        display_msg = "OBSERVABLE";
    else
        display_msg = "NO OBSERVABLE";        
    end
    disp("Matriz de observabilidad:");
    disp(O_);
    fprintf("El sistema es %s desde %s por que su rango = %d\n", display_msg, char(x(i)), rango);
end

% Criterio de observabilidad para [theta_m(t), ids(t)]
O_theta_ids = observabilidad_kalman(A, [1 0 0 1]);
fprintf("Rango matriz observabilidad para C = [1 0 0 1]: %d\n", rank(O_theta_ids));

%=================================================
%                Controlabilidad
%=================================================
disp("==== CONTROLABILIDAD ====")
m = length(u);

B_aux = B(:,1:m-1);  % La entrada T_l es una perturbacion (no se puede controlar). Usamos solo la tension v_q

entradas_msg = "[";
for i=1:m-2
    entradas_msg = entradas_msg + char(u(i)) + ", ";
end
entradas_msg = entradas_msg + char(u(m-1)) + "]";

C_ = controlabilidad_kalman(A, B_aux);
rango = rank(C_);

if rango == n
    display_msg = "CONTROLABLE";
else
    display_msg = "NO CONTROLABLE";
end
disp("Matriz de controlabilidad");
disp(C_);
fprintf("El sistema es %s desde %s por que su rango = %d\n", display_msg, entradas_msg, rango);

function O_ = observabilidad_kalman(A, C)
n = length(A);
O_= [];
for i=1:n
    O_ = [O_; simplify(C*A^(i-1))];
end
end

function C_ = controlabilidad_kalman(A, B)
n = length(A);
C_ = [];
for i=1:n
    C_ = [C_ A^(i-1)*B];
end
end