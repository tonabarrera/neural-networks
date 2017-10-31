%% Perceptron
function perceptron()
    if 1
        aprendizaje();
    else
        metodo_grafico();
    end;
end

%% Proceso de aprendizaje
function aprendizaje()
    % pedir valores al usuario (itmax & Eit)
    p1 = [1 -1 -1]';
    p2 = [1 1 -1]';
    prototipos = [p1 p2];
    dimen = size(prototipos);
    targets = [0 1];
    S = 1; % Maximo 2 debido a que puede clasificar 4 clases
    R = dimen(1); % Elementos de los vectores
    Eit = 0.01;
    itmax = 5;
    W = rand(S, R);
    b = rand(S, 1);
    
    auxiliar_w = fopen('auxiliar_w.txt', 'w');
    auxiliar_bias = fopen('auxiliar_bias.txt', 'w');
    auxiliar_error = fopen('auxiliar_error.txt', 'w');
    fprintf(auxiliar_w, '%f ', W);
    fprintf(auxiliar_w, '\n');
    
    fprintf(auxiliar_bias, '%f ', b);
    fprintf(auxiliar_bias, '\n');
    for iteracion = 1:itmax
        error = 0;
        for i = 1:dimen(2)
            p = prototipos(:, i);
            a = hardlim(W*p + b);
            e = targets(i) - a;
            W = W + (e*p');
            b = b + e;
            error = error + e;
        end
        fprintf(auxiliar_w, '%f ', W);
        fprintf(auxiliar_w, '\n');
        
        fprintf(auxiliar_bias, '%f ', b);
        fprintf(auxiliar_bias, '\n');
        
        fprintf(auxiliar_error, '%f ', error);
        fprintf(auxiliar_error, '\n');
    end
    fclose(auxiliar_error);
    fclose(auxiliar_w);
    fclose(auxiliar_bias);
    % Desplegar en que interacion termino
    % Desplegar el criterio de terminacion
    % Desplegar valores finales de pesos y bias
    
    % Graficar pesos y bias y el error por iteracion
    % Figura de los valores de W
        valoresW = dlmread('auxiliar_w.txt');
        valores_bias = dlmread('auxiliar_bias.txt');
        graficar_pesos(valoresW, iteracion, valores_bias);
    % Final de la grafica de W
    
    % Otra figura para mostrar en otra ventana
        valoresEit = dlmread('auxiliar_error.txt');
        graficar_error(iteracion, valoresEit)
    % Final de la grafica de error
    
    % Almacenar pesos y bias en archivo resultado_hora_fecha.txt
    
end

%% Grafico
function metodo_grafico()
end


%% graficar_pesos: function description
function graficar_pesos(valoresW, iteracion, valores_bias)
    figure('Name', 'Evolución de los pesos y bias');
    % Grafica un vector en x y otro vector en y
    plot(0:iteracion, valoresW, 'LineWidth', 2); 
    hold;
    plot(0:iteracion, valoresW, '*');
    plot(0:iteracion, valores_bias, 'LineWidth', 2);
    grid;
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('W & bias');

    title('Valores de W & bias');
end

%% graficar_error: function description
function graficar_error(iteracion, valoresEit)
    figure('Name', 'Error Eit');
    x = 1:iteracion;
    % Grafica un vector en x y otro vector en y
    plot(x, valoresEit, 'LineWidth', 2);
    hold;
    plot(x, valoresEit, '*', 'LineWidth', 2);
    grid;
    % Imprime las coordenadas de Eit
    strValues = strtrim(cellstr(num2str([x(:) valoresEit(:)], '(%d,%d)')));
    text(x, valoresEit, strValues, 'VerticalAlignment', 'bottom');
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('E_{it}');
    % Titulo de nuestra grafica
    title('Valores de E_{it}');
end
