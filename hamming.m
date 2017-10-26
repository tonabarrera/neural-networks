% Cada elemento del vector de entrada tiene solo dos posibles valores
archivo = dlmread('entrada_hamming.txt');
tam = size(archivo);
% Tamaño de nuestros vectores prototipo
R = tam(2);

% Numero de neuronas, corresponde a cada vector prototipo
S = tam(1) - 1;

% Vectores prototipos
%p1 = [1 -1 -1]; % Naranja
%p2 = [1 1 -1]; % Manzana
%p3 = [-1 1 -1]; % Banana
%p4 = [-1 -1 1]; % Piña
% Vector a clasificar
% Inicializar el vector prueba
p = archivo(S+1, :)';

% Las filas de W1 son los vectores prototipos
% Inicializacion de W1
W1 = archivo(1:S, :);
% Asignacion de los vectores prototipo
%W1(1, :) = p1;
%W1(2, :) = p2;
%W1(3, :) = p3;
%W1(4, :) = p4;
% Cada elemento del bias es el tamaño del vector prototipo
% Inicializacion del bias
b1 = ones(S, 1);
% Asignacion de valores
b1(1, :) = R;
b1(2, :) = R;

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


% Aqui se guardara la salida de la capa recurrente
% Metomos la salida de la capa anterior
a2_recurrente(:, 1) = a2;

% Recurrencia de la capa
t = 1;
while true
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
    t = t + 1;
end;

% Fin de la capa recurrente
fprintf('Termino en la iteración %d\n', t);
v = 0;
for ite = a2
    if ite ~= 0
        break;
    else
        v = v+1;
    end;
end
fprintf('La clase a la que converjio fue: %d\n', v);
% Imprimir datos y graficar la salida de a2
a2_recurrente = a2_recurrente(:, 1:t+1);
figure('Name', 'Evolución de la salida de la capa recurrente');
plot(0:t, a2_recurrente, 'LineWidth', 2);
hold;
grid;
xlabel('t');
ylabel('a^2(t)');
etiquetas = cell(1, S);
for i = 1:S
    etiquetas{i} = ['P_' num2str(i)];
end;
legend(etiquetas);

