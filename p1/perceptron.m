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
    p1 = [1 1]';
    p2 = [2 -1]';
    p3 = [-1 2]';
    p4 = [-1 -1]';
    prototipos = [p1 p2, p3 p4];
    dimen = size(prototipos);
    t1 = [0 0]';
    t2 = [0 1]';
    t3 = [1 0]';
    t4 = [1 1]';
    targets = [t1 t2 t3 t4];
    S = 2; % Maximo 2 debido a que puede clasificar 4 clases
    R = dimen(1); % Elementos de los vectores
    itmax = input('Ingrese valor de itmax: ', 's'); %5
    itmax = str2double(itmax);
    W = rand(S, R);
    b = rand(S, 1);
    
    auxiliar_w = fopen('auxiliar_w.txt', 'w');
    auxiliar_bias = fopen('auxiliar_bias.txt', 'w');
    auxiliar_error = fopen('auxiliar_error.txt', 'w');
    fprintf(auxiliar_w, '%.10f ', W);
    fprintf(auxiliar_w, '\n');
    
    fprintf(auxiliar_bias, '%.10f ', b);
    fprintf(auxiliar_bias, '\n');
    for iteracion = 1:itmax
        error = 0;
        for i = 1:dimen(2)
            p = prototipos(:, i);
            a = hardlim(W*p + b);
            e = targets(:, i) - a;
            W = W + (e*p');
            b = b + e;
            error = error + e;
        end
        error = 1/dimen(2) * error;
       
        fprintf(auxiliar_w, '%.10f ', W);
        fprintf(auxiliar_w, '\n');
        
        fprintf(auxiliar_bias, '%.10f ', b);
        fprintf(auxiliar_bias, '\n');
        
        fprintf(auxiliar_error, '%.10f ', error);
        fprintf(auxiliar_error, '\n');
        
        aux = 0;
        for e = error
            aux = aux + e;
        end
        if aux == 0
            break;
        end
    end
    
    fclose(auxiliar_error);
    fclose(auxiliar_w);
    fclose(auxiliar_bias);
    
    % Figura de los valores de W
        valoresW = dlmread('auxiliar_w.txt');
        valores_bias = dlmread('auxiliar_bias.txt');
        graficar_pesos(valoresW, iteracion, S, R);
        graficar_bias(valores_bias, iteracion, S);
    % Final de la grafica de W
    
    % Otra figura para mostrar en otra ventana
        valoresEit = dlmread('auxiliar_error.txt');
        graficar_error(iteracion, valoresEit, S);
    % Final de la grafica de error
    
    % Criterio de terminacion
    if iteracion == itmax
        disp('Termino debido a que llego a la iteración máxima');
    else
        fprintf('Termino  en la iteracion %d porque logro converger, ', iteracion);
        disp('la salida es igual al target');
    end;
    % Final del criterio de terminacion
    
    % Desplegar valores finales de pesos y bias
    % Almacenar pesos y bias en archivo resultado_hora_fecha.txt
    fprintf('Valores finales de W: \n');
    fprintf('%10f ', W);
    fprintf('\n');
    
    fprintf('Valores finales del bias: \n');
    fprintf('%10f ', b);
    fprintf('\n');
    archivo_final = strcat('resultado_', datestr(now, 'HH-MM_dd-mm-yyyy'));
    archivo_final = strcat(archivo_final, '.txt');
    finales = fopen(archivo_final, 'w');
    fprintf(finales, 'Valores finales de W: \n');
    fprintf(finales, '%.10f ', W);
    fprintf(finales, '\n');
    
    fprintf(finales, 'Valores finales del bias: \n');
    fprintf(finales, '%.10f ', b);
    fprintf(finales, '\n');
    fclose(finales);
end

%% Grafico
function metodo_grafico()
end

%% graficar_bias
function graficar_bias(valores_bias, iteracion, S)
    figure('Name', 'Evolución del bias');
    % Grafica un vector en x y otro vector en y
    plot(0:iteracion, valores_bias, 'LineWidth', 2); 
    hold;
    grid;
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('Bias');
    % Titulo de nuestra grafica
    etiquetas = cell(1, S);
    for i = 1:S
        etiquetas{i} = ['bias_' num2str(i)];
    end;
    legend(etiquetas);
    title('Valores del bias');
end
%% graficar_pesos: function description
function graficar_pesos(valoresW, iteracion, S, R)
    figure('Name', 'Evolución de los pesos');
    % Grafica un vector en x y otro vector en y
    plot(0:iteracion, valoresW, 'LineWidth', 2); 
    hold;
    grid;
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('W');
    
    etiquetas = cell(1, S*R);
    k = 1;
    for i = 1:S
        for j = 1:R
            etiquetas{k} = ['W_{' num2str(i) ',' num2str(j) '}'];
            k = k+1;
        end;
    end;
    legend(etiquetas);
    title('Valores de W');
end

%% graficar_error: function description
function graficar_error(iteracion, valoresEit, S)
    figure('Name', 'Error Eit');
    x = 1:iteracion;
    % Grafica un vector en x y otro vector en y
    plot(x, valoresEit, 'LineWidth', 2);
    hold;
    grid;
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('E_{it}');
    % Titulo de nuestra grafica
    etiquetas = cell(1, S);
    for i = 1:S
        etiquetas{i} = ['Neurona ' num2str(i)];
    end;
    legend(etiquetas);
    % Titulo de nuestra grafica
    title('Valores de E_{it}');
end
