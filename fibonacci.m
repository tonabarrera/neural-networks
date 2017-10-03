% Funcion principal que se ejecutara al inicio
function fibonacci
    % Aqui guardaremos valores de la sucesion para no tener que volver a calcularlos
    global valores;
    % Pedimos el numero de terminos a imprimir
    numero = input('Introduce el numero de terminos:');
    % Inicializamos nuestro arreglo con zeros
    valores = zeros(1, numero);
    fprintf('Los primeros %d terminos son:\n', numero);
    % For para imprimir los valores
    for i=0:numero-1
        fprintf('%d ', f(i));
    end
    fprintf('\n');
end

% Funcion que calcula los elementos de la sucesion
function resultado=f(x)
    global valores;
    % Si ya esta en el arreglo ya no lo volvemos a calcular
    if (valores(x+1) ~= 0)
        resultado = valores(x+1);
    else if (x == 0)
        resultado = 0; % Condicion inicial para 0
    else if (x == 1)
        resultado = 1; % Condicion inicial para 1
    else
        valores(x+1) = f(x-1) + f(x-2); % Calculo de los terminos mediante recursion
        resultado = valores(x+1);
        end
        end
    end
end