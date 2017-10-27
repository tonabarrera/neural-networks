eit = 0.01;
alpha = 0.3;
itmax = 10; % Iteración máxima
Eit = zeros(1, itmax);
opcion = inputdlg('1.-Red con bias   2.-Red sin bias', 'Elige una opción');
if str2double(opcion{1}) == 1
    disp('Espera');
else
    tam = inputdlg('Dame el tamaño del codificador perro', 'Codificador');
    tam = str2double(tam{1});
    tabla_verdad = zeros(2^tam, tam+1);
    N = 2^tam-1;
    valorW = zeros(itmax+1, tam);
    W = rand(1, tam);
    valorW(1, :) = W;
    for i = 0:N
        a = dec2bin(i, tam) - '0';
        tabla_verdad(i+1, 1:tam) = a;
        tabla_verdad(i+1, tam+1) = i;
    end;
    
    for iteracion = 1:itmax
        for n = 1:N
            p = tabla_verdad(n, 1:tam)';
            disp(p');
            a = purelin(W*p);
            t = tabla_verdad(n, tam+1);
            ed = t-a;
            Eit(iteracion) = Eit(iteracion) + ed;
            W = W + (2 * alpha * ed*p');
        end
        Eit(iteracion) = 1/N * Eit(iteracion);
        valorW(iteracion+1, :) = W;
        if Eit(iteracion) == 0
            disp('Iguales');
            break;
        elseif Eit(iteracion) < eit
            disp('Menor');
            break;
        else
            disp('Aun no');
        end
    end
    
    % Figura de los valores de W
figure;
% Grafica un vector en x y otro vector en y
plot(0:iteracion, valorW(1:iteracion+1, :), 'LineWidth', 2); 
hold;
plot(0:iteracion, valorW(1:iteracion+1, :), '*');
grid;
% Etiquetas de los ejes
xlabel('Iteración');
ylabel('W');
% Titulo de nuestra grafica
legend('W_{1}', 'W_{2}', 'W_{3}');
title('Valores de W');

% Otra figura para mostrar en otra ventana
figure;
x = 1:iteracion;
Eit = Eit(1:iteracion);
% Grafica un vector en x y otro vector en y
plot(x, Eit, 'LineWidth', 2);
hold;
plot(x, Eit, '*', 'LineWidth', 2);
grid;
% Imprime las coordenadas de Eit
strValues = strtrim(cellstr(num2str([x(:) Eit(:)],'(%d,%d)')));
text(x,Eit,strValues,'VerticalAlignment', 'bottom');
% Etiquetas de los ejes
xlabel('Iteración');
ylabel('E_{it}');
% Titulo de nuestra grafica
title('Valores de E_{it}');
disp(Eit);
disp(valorW);
end