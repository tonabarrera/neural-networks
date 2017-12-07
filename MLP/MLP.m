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
    puntos(:, 2) = sin(pi*puntos(:, 1));
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
    arqui = [1 4 3 1];
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
    Eval = 0;
    error_aprendizaje = 0;
    f_errores = fopen('errores.txt', 'w');
    for iteracion = 1:itmax
        % Condiciones de finalizacion
        if mod(iteracion, itval) == 0
            fprintf('Iteracion de validacion %d incremento: %d\n', iteracion, incrementos);
            fprintf('El error %d\n', error_aprendizaje);
            error_validacion = iteracion_validacion(W, b, datos_validacion);
            fprintf(f_errores, '%.10f 0\n', error_validacion);
            if error_validacion > Eval
                incrementos = incrementos + 1;
            else
                incrementos = 0;
            end
            Eval = error_validacion;
            if incrementos == num_val
                break;
            end
        else
            [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos_aprendizaje, alpha);
            fprintf(f_errores, '%.10f 1\n', error_aprendizaje);
            if error_aprendizaje < Eit
                break
            end
        end 
    end
    fclose(f_errores);
    graficar_errores(itmax, itval);
    [datos_prueba, Ep]= iteracion_prueba(W, b, datos_prueba);
    guardar_valores_finales(W, b);
    graficar_salida(datos_prueba);
    graficar_pesos();
    graficar_bias();
    imprimir_errores(error_aprendizaje, Ep, Eval);
end

function guardar_valores_finales(W, b)
    capas = length(W);
    for i = 1:capas
        archivo_W = strcat('W_final_', num2str(i));
        archivo_W = strcat(archivo_W, '.txt');
        archivo_b = strcat('b_final_', num2str(i));
        archivo_b = strcat(archivo_b, '.txt');
        f_pesos = fopen(archivo_W, 'w');
        f_bias = fopen(archivo_b, 'w');
        fprintf(f_pesos, '%.10f ', W{i});
        fprintf(f_pesos, '\n');
        fprintf(f_bias, '%.10f ', b{i});
        fprintf(f_bias, '\n');
        fclose(f_pesos);
        fclose(f_bias);
    end
end

function graficar_salida(datos_prueba)
    figure('Name', 'Salida del MLP vs el conjunto de prueba');
    plot(datos_prueba(:, 1)', datos_prueba(:, 2)', 'o', 'Color', 'g');
    hold;
    grid;
    plot(datos_prueba(:, 1)', datos_prueba(:, 3)', 'x', 'Color', 'r');
    title('Salida del MLP vs el conjunto de prueba');
    xlabel('p');
    ylabel('g(p)');
    legend('Prueba', 'MLP');
end

function graficar_pesos()
    global arqui;
    capas = length(arqui) - 1;
    for i = 1:capas
        titulo = strcat('Evolución de los pesos de la capa #', num2str(i));
        figure('Name', titulo);
        grid;
        hold;
        archivo_W = strcat('W_', num2str(i));
        archivo_W = strcat(archivo_W, '.txt');
        W_bias = load(archivo_W);
        filas = length(W_bias);
        etiquetas = cell(1, arqui(i)*arqui(i+1));
        k = 1;
        for j = 1:arqui(i)
            for l = 1:arqui(i+1)
                etiquetas{k} = ['W_{' num2str(j) ',' num2str(l) '}'];
                k = k + 1;
            end
        end;
        plot(0:filas-1, W_bias);
        title(titulo);
        xlabel('Iteración');
        ylabel('W');
        legend(etiquetas);
    end
end

function graficar_bias()
    global arqui;
    capas = length(arqui) - 1;
    for i = 1:capas
        titulo = strcat('Evolución del bias de la capa #', num2str(i));
        figure('Name', titulo);
        grid;
        hold;
        archivo_b = strcat('b_', num2str(i));
        archivo_b = strcat(archivo_b, '.txt');
        f_bias = load(archivo_b);
        [filas, columnas] = size(f_bias);
        etiquetas = cell(1, columnas);
        for j = 1:columnas
            etiquetas{j} = ['b_' num2str(j)];
        end;
        plot(0:filas-1, f_bias);
        title(titulo);
        xlabel('Iteración');
        ylabel('Bias');
        legend(etiquetas);
    end
end

function imprimir_errores(error_aprendizaje, Ep, Eval)
    fprintf('--------------Valores finales del MLP--------------------\n');
    fprintf('El error de aprendizaje fue: %d \n', error_aprendizaje);
    fprintf('El error de prueba fue: %d \n', Ep);
    fprintf('El error de validacion fue: %d \n', Eval);
    fprintf('---------------------------------------------------------\n');
end

function graficar_errores(itmax, itval)
    vector_errores = load('errores.txt');
    vector_validacion = zeros(2, itmax/itval);
    vector_aprendizaje = zeros(2, itmax-itmax/itval);
    j = 1;
    k = 1;
    for i = 1: length(vector_errores)
        if vector_errores(i, 2) == 0
            vector_validacion(2, j) = vector_errores(i, 1);
            vector_validacion(1, j) = i;
            j = j + 1;
        else
            vector_aprendizaje(2, k) = vector_errores(i, 1);
            vector_aprendizaje(1, k) = i;
            k = k + 1;
        end
    end
    figure('Name', 'Evolución de los errores de validacion y aprendizaje');
    plot(vector_validacion(1,:), vector_validacion(2,:), 'o');
    hold;
    plot(vector_aprendizaje(1,:), vector_aprendizaje(2,:), '*');
    grid;
    xlabel('Iteración');
    ylabel('Error');
    legend('Error de validacion', 'Error de aprendizaje');
end

function [W, b] = inicializar()
    global arqui;
    capas = length(arqui) - 1;
    b = cell([1 capas]);
    W = cell([1 capas]);
    
    for i = 1:capas
        archivo_W = strcat('W_', num2str(i));
        archivo_W = strcat(archivo_W, '.txt');
        archivo_b = strcat('b_', num2str(i));
        archivo_b = strcat(archivo_b, '.txt');
        f_pesos = fopen(archivo_W, 'w');
        f_bias = fopen(archivo_b, 'w');
        S = arqui(i+1);
        R = arqui(i);
        W{i} = -1 + (1-(-1)) * rand(S, R);
        fprintf(f_pesos, '%.10f ', W{i});
        fprintf(f_pesos, '\n');
        b{i} = -1 + (1-(-1)) * rand(S, 1);
        fprintf(f_bias, '%.10f ', b{i});
        fprintf(f_bias, '\n');
        fclose(f_bias);
        fclose(f_pesos);
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

function [datos_prueba, error_prueba] = iteracion_prueba(W, b, datos_prueba)
    global vector_func;
    global FUNCIONES;
    error_prueba = 0;
    for i = 1:length(datos_prueba)
        p = datos_prueba(i, 1);
        for j = 1:length(vector_func)
            a = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a;
        end
        error_prueba = abs(datos_prueba(i, 2) - a);
        datos_prueba(i, 3) = a;
    end
    error_prueba = error_prueba / length(datos_prueba);    
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
    for i = 1:capas
        archivo_W = strcat('W_', num2str(i));
        archivo_W = strcat(archivo_W, '.txt');
        archivo_b = strcat('b_', num2str(i));
        archivo_b = strcat(archivo_b, '.txt');
        f_pesos = fopen(archivo_W, 'a');
        f_bias = fopen(archivo_b, 'a');
        fprintf(f_pesos, '%.10f ', W{i});
        fprintf(f_pesos, '\n');
        fprintf(f_bias, '%.10f ', b{i});
        fprintf(f_bias, '\n');
        fclose(f_bias);
        fclose(f_pesos);
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
    
    for i = 1:M
        archivo_W = strcat('W_', num2str(i));
        archivo_W = strcat(archivo_W, '.txt');
        archivo_b = strcat('b_', num2str(i));
        archivo_b = strcat(archivo_b, '.txt');
        f_pesos = fopen(archivo_W, 'a');
        f_bias = fopen(archivo_b, 'a');
        fprintf(f_pesos, '%.10f ', W{i});
        fprintf(f_pesos, '\n');
        fprintf(f_bias, '%.10f ', b{i});
        fprintf(f_bias, '\n');
        fclose(f_bias);
        fclose(f_pesos);
    end
    
    error_iteracion = error_iteracion/length(datos);
end