% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%           PARAMETROS DE SIMULACION
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Invocacion script de parametros
parametros_de_sistema;

t_stop = 3; % [s]
T_s = t_stop/300; % [s]
options = simset('fixedstep', T_s);

% Simular
sim('sistema_completo_nl', t_stop, options); 