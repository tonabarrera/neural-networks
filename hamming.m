% Cada elemento del vector de entrada tiene solo dos posibles valores

% Tamaño de nuestros vectores prototipo
R = 2;

% Numero de neuronas, corresponde a cada vector prototipo
S = 2;

% Vectores prototipos
p1 = [1 .5];
p2 = [2 1];

% Vector a clasificar
% Inicializar el vector prueba
p = ones(R, 1);
p(1) = 1;
p(2) = 0;

% Las filas de W1 son los vectores prototipos
% Inicializacion de W1
W1 = ones(S, R);
% Asignacion de los vectores prototipo
W1(1, :) = p1;
W1(2, :) = p2;

% Cada elemento del bias es el tamaño del vector prototipo
% Inicializacion del bias
b1 = ones(S, 1);
% Asignacion de valores
b1(1, :) = 3;
b1(2, :) = 3;

% Propagamos hacia adelante
a1 = purelin((W1*p)+b1);
% Fin de la capa feedforward

%Inicio de la capa recurrente
% Hacemos a2(0) = a2
a2 = a1;
% Obtencion del valor epsilon 0 < epsilon < 1/(S-1)
epsilon = round(rand(1)*1/(S-1), 2); 
% Inicializacion y llenado de la W2 de la capa recurrente
W2 = ones(S, S);
for i = 1:S
    for j = 1:S
        if i==j
            W2(i, j) = 1;
        else
            W2(i, j) = -epsilon; 
        end;
    end;
end;

% La capa recurrente hara maximo 10 iteraciones
MAX_ITERACION = 10;

% Aqui se guardara la salida de la capa recurrente
% +1 debido al elemento a(0)
a2_recurrente = ones(2,MAX_ITERACION+1);
% Metomos la salida de la capa anterior
a2_recurrente(:, 1) = a2;

% Recurrencia de la capa
for t = 1:MAX_ITERACION
    % Obtenemos el t+1
    a2_sig = poslin(W2*a2);
    a2_recurrente(:, t+1) = a2_sig;
    if a2_sig == a2
        % Si ya terminamos detenemos el ciclo
        break;
    else
        % Siguiente iteracion
        a2 = a2_sig;
    end;
end;

% Fin de la capa recurrente
disp(t);
disp(a2)
disp(a2_sig);