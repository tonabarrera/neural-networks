%% Funcion principal
function MLP()
    global FUNCIONES;
    FUNCIONES = {@purelin, @logsig, @tansig};
    %     archivo_datos = input('Ingrese el nombre del archivo de datos: ', 's');
    %     archivo_targets = input('Ingrese el nombre del archivo de targets: ', 's');
    %     rango_entrada = input('Ingrese el nombre del archivo de targets: ', 's');
    % rango = [-2 2];
    puntos = zeros(200, 2);
    puntos(:, 1) = -2 + (2-(-2)) * rand(200, 1);
    puntos(:, 1) = sort(puntos(:, 1));
    puntos(:, 2) = 1 + sin(2*pi*puntos(:, 1)/4);
    datos_aprendizaje = zeros(160, 2);
    datos_validacion = zeros(20, 2);
    datos_prueba = zeros(20, 2);
    j = 1;
    k = 1;
    l = 1;
    i = 1;
    while (i <= 200)
        if mod(i, 10) == 0
            datos_prueba(j, 1) = puntos(i, 1);
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
    arqui = [1 4 2 3 1];
    %     funciones_entrada = input('Ingrese el vector de funciones de la arqui: ', 's');
    vector_funciones = [2 2 2 1];
    %     alpha = input('Ingrese el factor de aprendizaje (alpha): ');
    alpha = 0.05;
    %     itmax = input('Ingrese el numero maximo de iteraciones: ');
    itmax = 1000;
    %     Eit = input('Ingrese el error de entrenamiento de una iteracion: ');
    Eit = 0.003;
    %     itval = input('Ingrese el intervalo de validacion: ');
    itval = 5;
    %     num_val = input('Ingrese el numero de incrementos consecutivos: ');
    num_val = 5;
    %     division = input('Elija si dividir 1) 80-10-10 o 2) 70-15-15: ');
    [W, b] = inicializar(arqui);
    incrementos = 0;
    error_validacion_temp = 0;
    error_aprendizaje = 0;
    for iteracion = 1:itmax
        % Condiciones de finalizacion
        if mod(iteracion, itval) == 0
            fprintf('Iteracion de validacion %d\n', iteracion);
            error_validacion = iteracion_validacion(W, b, datos_validacion, arqui, vector_funciones);
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
            [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos_aprendizaje, arqui, alpha, vector_funciones);
            if error_aprendizaje < Eit
                break
            end
        end 
    end
    for i = 1:length(datos_prueba)
        p = datos_prueba(i, 1);
        for j = 1:length(vector_funciones)
            a = FUNCIONES{vector_funciones(j)}(W{j} * p + b{j});
            p = a;
        end
        datos_prueba(i, 2) = a;
    end
    fprintf('Error de aprendizaje: %d Eit: %d\n', error_aprendizaje, Eit);
    figure;
    plot(datos_prueba(:, 1)', datos_prueba(:, 2)');
    hold;
    grid;
    plot(datos_validacion(:, 1)', datos_validacion(:, 2)');
    plot(datos_aprendizaje(:, 1)', datos_aprendizaje(:, 2)');
    plot(puntos(:, 1)', puntos(:, 2)');
    legend('Prueba', 'Validacion', 'Aprendizaje', 'Todos');
end

function [W, b] = inicializar(arqui)
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

function [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos, arqui, alpha, vector_func)
    global FUNCIONES;
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
            for j = 1:arqui(k+1)
                Fn(j, j) = (1-a{k}(j)) * a{k}(j);
            end
            s{k} = Fn * W{k+1}' * s{k+1};
        end
        W{1} = W{1} - alpha * s{1} * datos(i, 1)';
        b{1} = b{1} - alpha * s{1};
    end
    error_aprendizaje = error_aprendizaje / length(datos);
end

function error_iteracion = iteracion_validacion(W, b, datos, arqui, vector_func)
    global FUNCIONES;
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