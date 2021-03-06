%1 8 1
% 3 1
% 0.03
function MLP()
    % Funcion principal del perceptron multicapa
    
    % Variables globales que se utilizan mucho y no cambian
    global FUNCIONES;
    global arqui;
    global vector_func;
    % Funciones que se pueden utilizar
    FUNCIONES = {@purelin, @logsig, @tansig};
    archivo_datos = input('Ingrese el nombre del archivo de datos: ', 's');
    archivo_targets = input('Ingrese el nombre del archivo de targets: ', 's');
    rango_entrada = input('Ingrese rango de la función: ', 's');
    entradas = load(archivo_datos);
    targets = load(archivo_targets);
    % Total de datos 
    num_datos = length(entradas);
    % Como se dividiran los datos
    division = input('Elija si dividir 1) 80-10-10 o 2) 70-15-15: ');
    divisor = .8;
    if division == 2
        divisor = .7;
    end
    % Total de datos de entrenamiento, prueba y validacion
    tam_entrenamiento = round(num_datos * divisor);
    tam_prueba = (num_datos - tam_entrenamiento);
    tam_validacion = tam_prueba;
    % Inicializacion de matrices
    datos_aprendizaje = zeros(tam_entrenamiento, 2);
    datos_validacion = zeros(tam_validacion, 2);
    datos_prueba = zeros(tam_prueba, 3);
    j = 1;
    k = 1;
    i = 1;
    % Distribucion de los datos
    while (i <= num_datos)
        if mod(i, 5) == 0
            datos_validacion(k, 1) = entradas(i);
            datos_validacion(k, 2) = targets(i);
            datos_prueba(k, 1) = entradas(i);
            datos_prueba(k, 2) = targets(i);
            k = k +1;
        else
            datos_aprendizaje(j, 1) = entradas(i);
            datos_aprendizaje(j, 2) = targets(i);
            j = j + 1;
        end
        i = i + 1;
    end
    arqui_entrada = input('Ingrese el vector de la arquitectura: ', 's');
    arqui_entrada = textscan(arqui_entrada, '%d', 'Delimiter', ' ' );
    arqui = permute(arqui_entrada{1}, [2, 1]);
    fprintf('Ingrese el vector de funciones\n');
    fprintf('1.-pureline\n2.-logsig\n3.-tansig\n')
    funciones_entrada = input('Solo los numeros: ', 's');
    funciones_entrada = textscan(funciones_entrada, '%d', 'Delimiter', ' ' );
    vector_func = permute(funciones_entrada{1}, [2, 1]);
    alpha = input('Ingrese el factor de aprendizaje (alpha): ');
    itmax = input('Ingrese el numero maximo de iteraciones: ');
    Eit = input('Ingrese el error de entrenamiento de una iteracion: ');
    itval = input('Ingrese el intervalo de validacion: ');
    num_val = input('Ingrese el numero de incrementos consecutivos: ');
    
    % Inicializacion de variables
    [W, b] = inicializar();
    incrementos = 0; % Contador incrementos
    Eval = 0; % Error de validacion
    error_aprendizaje = 0;
    % Archivo para almacenar el error de aprendizaje y validacion
    f_errores = fopen('errores.txt', 'w');
    % Variable para saber el criterio de finalizacion
    condicion_finalizacion = 0;
    % Comenzamos las iteraciones
    for iteracion = 1:itmax
        % Iteracion de valicacion
        if mod(iteracion, itval) == 0
            fprintf('#%d aprendizaje: %d validacion: %d\n', iteracion, error_aprendizaje, Eval);
            error_validacion = iteracion_validacion(W, b, datos_validacion);
            fprintf(f_errores, '%.10f 0\n', error_validacion);
            % Comparacion de errores de validacion
            if error_validacion > Eval
                incrementos = incrementos + 1;
            else
                incrementos = 0;
            end
            Eval = error_validacion;
            % Si alcanzamos el maximo de intecrementos terminamos
            if incrementos == num_val
                condicion_finalizacion = 1;
                break;
            end
        else
            % Iteracion aprendizaje
            [error_aprendizaje, W, b] = iteracion_aprendizaje(W, b, datos_aprendizaje, alpha);
            fprintf(f_errores, '%.10f 1\n', error_aprendizaje);
            % Si cumple la condicion terminamos
            if error_aprendizaje < Eit
                condicion_finalizacion = 2;
                break
            end
        end 
    end
    fclose(f_errores);
    % Realizar la iteracion de prueba
    [datos_prueba, Ep]= iteracion_prueba(W, b, datos_prueba);
    % Graficacion e impresion de resultados
    graficar_original(entradas, targets);
    graficar_errores(itmax, itval);
    guardar_valores_finales(W, b);
    graficar_salida(datos_prueba);
    graficar_pesos();
    graficar_bias();
    mostrar_resultados(error_aprendizaje, Ep, Eval, condicion_finalizacion);
end

function graficar_original(entradas, targets)
    % Graficamos la funcion original
    figure('Name', 'Función original');
    plot(entradas, targets);
    hold;
    grid;
    title('Función original');
    xlabel('p');
    ylabel('g(p)');
end

function graficar_salida(datos_prueba)
    % Grafica de comparacion de resultados
    figure('Name', 'Salida del MLP vs el conjunto de prueba');
    plot(datos_prueba(:, 1)', datos_prueba(:, 2)', '-o', 'Color', 'g');
    hold;
    plot(datos_prueba(:, 1)', datos_prueba(:, 3)', '-x', 'Color', [0.54 0.27 0.07]);
    grid;
    title('Salida del MLP vs el conjunto de prueba');
    xlabel('p');
    ylabel('g(p)');
    legend('Prueba', 'MLP');
end

function graficar_pesos()
    % Grafica de evolucion de pesos de cada capa
    global arqui;
    capas = length(arqui) - 1;
    % Graficacion por capa
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
                etiquetas{k} = ['W^{' num2str(i) '}_{' num2str(l) ',' num2str(j) '}'];
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
    % Graficar evolucion del bias de cada capa
    global arqui;
    capas = length(arqui) - 1;
    % Bias de cada capa
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
            etiquetas{j} = ['b^{' num2str(i) '}_' num2str(j)];
        end;
        plot(0:filas-1, f_bias);
        title(titulo);
        xlabel('Iteración');
        ylabel('Bias');
        legend(etiquetas);
    end
end

function graficar_errores(itmax, itval)
    % Grafica de la evolucion del error de iteracion y validacion
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
    plot(vector_aprendizaje(1,:), vector_aprendizaje(2,:), '.');
    grid;
    xlabel('Iteración');
    ylabel('Error');
    title('Evolución de los errores de validacion y aprendizaje');
    legend('Error de validacion', 'Error de aprendizaje');
end

function mostrar_resultados(error_aprendizaje, Ep, Eval, condicion_fin)
    % Imprimir valores importantes de la red
    fprintf('--------------Valores finales del MLP--------------------\n');
    fprintf('El error de aprendizaje fue: %d \n', error_aprendizaje);
    fprintf('El error de prueba fue: %d \n', Ep);
    fprintf('El error de validacion fue: %d \n', Eval);
    fprintf('La condición de finalizacion es: ');
    if condicion_fin == 0
        fprintf('Maximo de iteraciones alcanzado\n');
    elseif condicion_fin == 1
        fprintf('Early stopping\n');
    else
        fprintf('Error de iteracion menor a Eit\n');
    end
    fprintf('---------------------------------------------------------\n');
end

function guardar_valores_finales(W, b)
    % Guardar la actualizacion de pesos y bias
    capas = length(W);
    % Hay un para bias y pesos por cada capa
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

function [W, b] = inicializar()
    global arqui;
    capas = length(arqui) - 1;
    b = cell([1 capas]);
    W = cell([1 capas]);
    % Inicializar y guardar los pesos y bias de cada capa
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

% Derivadas de las funciones que se utilizan
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
    % Propagacion del conjunto de prueba
    global vector_func;
    global FUNCIONES;
    error_prueba = 0;
    % Ciclo de los datos
    for i = 1:length(datos_prueba)
        p = datos_prueba(i, 1);
        % Ciclo de las capas de la red
        for j = 1:length(vector_func)
            % Seleccion de la funcion a utilizar
            a = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a;
        end
        e = datos_prueba(i, 2) - a;
        error_prueba = error_prueba + (e' * e);
        datos_prueba(i, 3) = a;
    end
    % Regresamos el error de prueba
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
    % Iteracion sobre todos los datos
    for i = 1:length(datos)
        p = datos(i, 1);
        % Propagacion hacia adelante
        for j = 1:length(vector_func)
            a{j} = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a{j};
        end
        e = datos(i, 2) - a{capas};
        error_aprendizaje = error_aprendizaje + (e' * e);
        % Aprendizaje realizado
        s{capas} = -2 * e;
        % Modificamos cada capa
        for m = capas-1:-1:1
            W{m+1} = W{m+1} - alpha * s{m+1} * a{m}';
            b{m+1} = b{m+1} - alpha * s{m+1};
            Fn = zeros(arqui(m+1));
            if vector_func(m) == 1
                % PURELING
                derivada = @derivada_purelin;
            elseif vector_func(m) == 2
                % LOGSIG
                derivada = @derivada_logsig;
            else
                % TANSIG
                derivada = @derivada_tansig;
            end
            for j = 1:arqui(m+1)
                 Fn(j, j) = derivada(a{m}(j));
            end
            s{m} = Fn * W{m+1}' * s{m+1};
        end
        % Primera capa
        W{1} = W{1} - alpha * s{1} * datos(i, 1)';
        b{1} = b{1} - alpha * s{1};
    end
    % Escritura de los valores
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
    % Se devuelve el error
    error_aprendizaje = error_aprendizaje / length(datos);
end

function error_iteracion = iteracion_validacion(W, b, datos)
    global FUNCIONES;
    global vector_func;
    global arqui;
    error_iteracion = 0;
    M = length(arqui) - 1;
    a = cell([1 M]);
    % Ciclo de propagacion de cada dato
    for i = 1:length(datos)
        p = datos(i, 1);
        % Propagacion atravez de las capas
        for j = 1:length(vector_func)
            % Seleccion de la funcion a utilizar
            % con base a su capa
            a{j} = FUNCIONES{vector_func(j)}(W{j} * p + b{j});
            p = a{j};
        end
        % Suma del error
        e = datos(i, 2) - a{M};
        error_iteracion = error_iteracion + (e' * e);
    end
    % Guardar los datos de esta iteracion aunque no se modificaron
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
    % Se devuelve el error de la validacion
    error_iteracion = error_iteracion/length(datos);
end