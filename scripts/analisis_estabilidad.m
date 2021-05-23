clear;clc;close all;
parametros_de_sistema;
% Sistema LTI simplificado
syms J b R_s;
A = [0 1                 0 
     0 -b/J        3*P_p*lambda_m/(2*J)
     0 -P_p*lambda_m/L_q -R_s/L_q];
B = [ 0     0           0
      0     -1/(J*r) 0
      1/L_q 0           0];
C = [1 0 0];
D = [0 0 0];

%-------------------------------------------------
% Analisis en valores nominales de J_l y b_l
%-------------------------------------------------
A_nom = double(subs(A, [J b R_s], [J_eq b_eq R_s_40]));
B_nom = double(subs(B, J, J_eq));
[num, den] = ss2tf(A_nom, B_nom, C, D, 2); %ni=1 => entrada en T_l (por el cero)
sys_nom = tf(num, den);

disp("Calculo de polos para Rs(40°C) y valores nominales");
p = vpa(pole(sys_nom));
disp(p)

disp("Calculo de ceros para Rs(40°C) y valores nominales");
z = zero(sys_nom);
disp(z)
% Gráfico de los polos y ceros
figure(1)
pzmap(sys_nom, 'b')
grid on

%-------------------------------------------------
% Teniendo en cuenta las variaciones de J_l y b_l
%-------------------------------------------------
% Valores maximos
J_eq_max = J_m + (J_l+dJ_l)/r^2;
b_eq_max = b_m + (b_l+db_l)/r^2;
A_max = double(subs(A, [J b R_s], [J_eq_max b_eq_max R_s_40]));
B_max = double(subs(B, J, J_eq_max));
[num, den] = ss2tf(A_max, B_max, C, D, 2); %ni=1 => entrada en T_l (por el cero)
sys_max = tf(num, den);

p_max = vpa(pole(sys_max));
z_max = zero(sys_max);

% Valores minimos
J_eq_min = J_m + (J_l-dJ_l)/r^2;
b_eq_min = b_m + (b_l-db_l)/r^2;
A_min = double(subs(A, [J b R_s], [J_eq_min b_eq_min R_s_40]));
B_min = double(subs(B, J, J_eq_min));
[num, den] = ss2tf(A_min, B_min, C, D, 2); %ni=1 => entrada en T_l (por el cero)
sys_min = tf(num, den);

p_min = vpa(pole(sys_min));
z_min = zero(sys_min);

figure(2)
pzmap(sys_nom, 'b', sys_max, 'r', sys_min, 'g')
grid on
legend('Nominal', 'Maximo', 'Minimo');

%-------------------------------------------------
% Teniendo en cuenta las variaciones de R_s con T°
%-------------------------------------------------

figure(3)
n = 10;
dT_i = 115/(10+1);
for T_i = 0:dT_i:115
    R_s_i = R_s_40*(1 + alpha_cu*(T_i - 40));
    A_nom_i = double(subs(A, [J b R_s], [J_eq b_eq R_s_i]));
    A_max_i = double(subs(A, [J b R_s], [J_eq_max b_eq_max R_s_i]));
    A_min_i = double(subs(A, [J b R_s], [J_eq_min b_eq_min R_s_i]));

    [num, den] = ss2tf(A_nom_i, B_nom, C, D, 2);
    sys_nom_i = tf(num, den);
    [num, den] = ss2tf(A_max_i, B_max, C, D, 2);
    sys_max_i = tf(num, den);    
    [num, den] = ss2tf(A_min_i, B_min, C, D, 2);
    sys_min_i = tf(num, den);    
    
    pzmap(sys_max_i, 'r', sys_min_i, 'g', sys_nom_i, 'b');
    hold on
    if (floor(T_i) == 41) || (ceil(T_i) == 115)
        hm = findobj(gca, 'Type', 'Line');          % Handle To 'Line' Objects
        hm(2).LineWidth = 2;                      % ‘Zero’ Marker
        hm(3).LineWidth = 2;                      % ‘Pole’ Marker
        hm(4).LineWidth = 2;                      % ‘Zero’ Marker
        hm(5).LineWidth = 2;                      % ‘Pole’ Marker
        hm(6).LineWidth = 2;                      % ‘Zero’ Marker
        hm(7).LineWidth = 2;                      % ‘Pole’ Marker
    end
end
grid on
legend('Nominal', 'Maximo', 'Minimo');

%=================================================
% Calculo de frecuencia natural y amortiguamiento
%=================================================
disp("Frecuencia natural y amortiguamiento a 40°C")
[wn_nom, zeta_nom] = damp(sys_nom);
[wn_max, zeta_max] = damp(sys_max);
[wn_min, zeta_min] = damp(sys_min);

disp(".   | nominal    |    max     |    min ")
fprintf('w_n | %f | %f | %f\n', wn_nom(2), wn_max(2), wn_min(2))
fprintf('ksi | %f   | %f   | %f\n', zeta_nom(2), zeta_max(2), zeta_min(2))

disp("Frecuencia natural y amortiguamiento a 115°C")
[wn_nom_115, zeta_nom_115] = damp(sys_nom_i); % sys_nom_i = Sistema a 115 °C (ver bucle for arriba)
[wn_max_115, zeta_max_115] = damp(sys_max_i);
[wn_min_115, zeta_min_115] = damp(sys_min_i);

disp(".   | nominal    |    max     |    min ")
fprintf('w_n | %f | %f | %f\n', wn_nom_115(2), wn_max_115(2), wn_min_115(2))
fprintf('ksi | %f   | %f   | %f\n', zeta_nom_115(2), zeta_max_115(2), zeta_min_115(2))

