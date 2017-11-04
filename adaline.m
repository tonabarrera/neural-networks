%% Funcion principal
function adaline()
    opcion = input('1.-Red con bias   2.-Red sin bias: ', 's');
    if str2double(opcion) == 1
        disp('Espera');
    else
        tam = input('Dame el tamaño del codificador: ', 's');
        tam = str2double(tam);
        tabla_verdad = zeros(2^tam, tam+1);
        eit = 0.01;
        alpha = input('Dame el valor de alpha: ', 's'); % 0.3
        alpha = str2double(alpha);
        N = 2^tam-1;
        W = rand(1, tam);
        auxiliar_w = fopen('auxiliar_w.txt', 'w');
        auxiliar_Eit = fopen('auxiliar_Eit.txt', 'w');
        fprintf(auxiliar_w, '%f ', W);
        fprintf(auxiliar_w, '\n');
        for i = 0:N
            a = dec2bin(i, tam) - '0';
            tabla_verdad(i+1, 1:tam) = a;
            tabla_verdad(i+1, tam+1) = i;
        end;
        continuar = true;
        iteracion = 1;
        while continuar
            Eit = 0;
            for n = 1:N
                p = tabla_verdad(n, 1:tam)';
                a = purelin(W*p);
                t = tabla_verdad(n, tam+1);
                ed = t-a;
                Eit = Eit + ed;
                W = W + (2 * alpha * ed*p');
            end
            % Guardar W y Eit
            Eit = 1/N * Eit;
            fprintf(auxiliar_Eit, '%f ', Eit);
            fprintf(auxiliar_Eit, '\n');

            fprintf(auxiliar_w, '%f ', W);
            fprintf(auxiliar_w, '\n');
            if Eit == 0
                disp('Criterio de igualdad a cero');
                break;
            elseif Eit < eit
                disp('Criterio de menor que el error');
                break;
            end
            iteracion = iteracion + 1;
        end
        fclose(auxiliar_Eit);
        fclose(auxiliar_w);
        % Figura de los valores de W
        valoresW = dlmread('auxiliar_w.txt');
        graficar_pesos(tam, valoresW, iteracion);
        % Final de la grafica de W

        % Otra figura para mostrar en otra ventana
        valoresEit = dlmread('auxiliar_Eit.txt');
        graficar_error(iteracion, valoresEit)
        % Final de la grafica de error
        
        disp('Valores finales de W');
        disp(W);
        valores_finales = fopen('resultado_hora_fecha.txt', 'w');
        fprintf(valores_finales, '%f ', W);
        fprintf(valores_finales, '\n');
        fclose(valores_finales);
    end
end % Final de la funcion principal

%% graficar_pesos: function description
function graficar_pesos(tam, valoresW, iteracion)
    figure('Name', 'Evolución de los pesos');
    % Grafica un vector en x y otro vector en y
    plot(0:iteracion, valoresW, 'LineWidth', 2); 
    hold;
    plot(0:iteracion, valoresW, '*');
    grid;
    % Etiquetas de los ejes
    xlabel('Iteración');
    ylabel('W');

    % Titulo de nuestra grafica
    etiquetas = cell(1, tam);
    for i = 1:tam
        etiquetas{i} = ['W_' num2str(i)];
    end;
    legend(etiquetas);
    title('Valores de W');
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


