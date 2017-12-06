%% Funcion principal
function MLP()
    global FUNCIONES;
    global arqui;
    global vector_func;
    FUNCIONES = {@purelin, @logsig, @tansig};
    %     archivo_datos = input('Ingrese el nombre del archivo de datos: ', 's');
    %     archivo_targets = input('Ingrese el nombre del archivo de targets: ', 's');
    %     rango_entrada = input('Ingrese el nombre del archivo de targets: ', 's');
    % rango = [-2 2];
    puntos = zeros(200, 2);
    puntos(:, 1) = -2 + (2-(-2)) * rand(200, 1);
    puntos(:, 1) = sort(puntos(:, 1));
    puntos(:, 2) = 1 + sin(4*pi*puntos(:, 1)/4);
    datos_aprendizaje = zeros(160, 2);
    datos_validacion = zeros(20, 2);
    datos_prueba = zeros(20, 3);
    j = 1;
    k = 1;
    l = 1;
    i = 1;
    while (i <= 200)
        if mod(i, 10) == 0
            datos_prueba(j, 1) = puntos(i, 1);
            datos_prueba(j, 2) = puntos(i, 2);
            j = j + 1;
        elseif mod(i, 5) == 0
            datos_validacion(k, 1) = puntos(i, 1);
            datos_validacion(k, 2) = puntos(i, 2);
            k = k + 1;
        else
            datos_aprendizaje(l, 1) = puntos(i, 1);
            datos_aprendizaje(l, 2) = puntos(i, 2);
            l = l + 1;
        end
        i = i + 1;
    end
    %     arqui_entrada = input('Ingrese el vector de la arquitectura: ', 's');
    arqui = [1 5 5 1];
    %     funciones_entrada = input('Ingrese el vector de funciones de la arqui: ', 's');
    vector_func = [2 2 1];
    %     alpha = input('Ingrese el factor de aprendizaje (alpha): ');
    alpha = 0.04;
    %     itmax = input('Ingrese el numero maximo de iteraciones: ');
    itmax = 5000;
    %     Eit = input('Ingrese el error de entrenamiento de una iteracion: ');
    Eit = 0.003;
    %     itval = input('Ingrese el intervalo de validacion: ');
    itval = 100;
    %     num_val = input('Ingrese el numero de incrementos consecutivos: ');
    num_val = 5;
    %     division = input('Elija si dividir 1) 80-10-10 o 2) 70-15-15: ');
    [W, b] = inicializar();
    incrementos = 0;
    error_validacion_temp = 0;
    error_aprendizaje = 0;
    for iteracion = 1:itmax
        % Condiciones de finalizacion
        if mod(iteracion, itval) == 0
            fprintf('Iteracion de validacion %d incremento: %d\n', iteracion, incrementos);
            fprintf('El error %d\n', error_aprendizaje);
            error_validacion = iteracion_validacion(W, b, datos_validacion);
            if error_validacion > error_validacion_temp
                incrementos = incrementos + 1;
            else
                incrementos = 0;
            end
            error_validacion_temp = error_validacion;
            if incrementos == num_val
                break;
            end
        else
            [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos_aprendizaje, alpha);
            if error_aprendizaje < Eit
                break
            end
        end 
    end
    datos_prueba = iteracion_prueba(W, b, datos_prueba);
    fprintf('Error de aprendizaje: %d Eit: %d\n', error_aprendizaje, Eit);
    figure;
    plot(datos_prueba(:, 1)', datos_prueba(:, 2)');
    hold;
    grid;
    plot(datos_prueba(:, 1)', datos_prueba(:, 3)');
    legend('Prueba', 'MLP');
end

function [W, b] = inicializar()
    global arqui;
    capas = length(arqui) - 1;
    b = cell([1 capas]);
    W = cell([1 capas]);
    for i = 1:capas
        S = arqui(i+1);
        R = arqui(i);
        W{i} = -1 + (1-(-1)) * rand(S, R);
        b{i} = -1 + (1-(-1)) * rand(S, 1);
    end
end

function valor = derivada_purelin(~)
    valor = 1;
end

function valor = derivada_logsig(a)
    valor = (1-a) * a;
end

function valor = derivada_tansig(a)
    valor = 1 - (a * a);
end

function datos_prueba = iteracion_prueba(W, b, datos_prueba)
    global vector_func;
    global FUNCIONES;
    for i = 1:length(datos_prueba)
        p = datos_prueba(i, 1);
        for j = 1:length(vector_func)
            a = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a;
        end
        datos_prueba(i, 3) = a;
    end
end

function [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos, alpha)
    global FUNCIONES;
    global vector_func;
    global arqui;
    error_aprendizaje = 0;
    capas = length(arqui) - 1;
    a = cell([1 capas]);
    s = cell([1 capas]);
    for i = 1:length(datos)
        p = datos(i, 1);
        for j = 1:length(vector_func)
            a{j} = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a{j};
        end
        e = datos(i, 2) - a{capas};
        error_aprendizaje = error_aprendizaje + abs(e);
        s{capas} = -2 * e;
        for k = capas-1:-1:1
            W{k+1} = W{k+1} - alpha * s{k+1} * a{k}';
            b{k+1} = b{k+1} - alpha * s{k+1};
            Fn = zeros(arqui(k+1));
            if vector_func(k) == 1
                % PURELING
                derivada = @derivada_purelin;
            elseif vector_func(k) == 2
                % LOGSIG
                derivada = @derivada_logsig;
            else
                % TANSIG
                derivada = @derivada_tansig;
            end
            for j = 1:arqui(k+1)
                 Fn(j, j) = derivada(a{k}(j));
            end
            s{k} = Fn * W{k+1}' * s{k+1};
        end
        W{1} = W{1} - alpha * s{1} * datos(i, 1)';
        b{1} = b{1} - alpha * s{1};
    end
    error_aprendizaje = error_aprendizaje / length(datos);
end

function error_iteracion = iteracion_validacion(W, b, datos)
    global FUNCIONES;
    global vector_func;
    global arqui;
    error_iteracion = 0;
    M = length(arqui) - 1;
    a = cell([1 M]);
    for i = 1:length(datos)
        p = datos(i, 1);
        for j = 1:length(vector_func)
            a{j} = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a{j};
        end
        e = datos(i, 2) - a{M};
        error_iteracion = error_iteracion + abs(e);
    end
    error_iteracion = error_iteracion/length(datos);
end