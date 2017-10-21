p1 = [0 0 0 0 1 1 1 1];
p2 = [0 0 1 1 0 0 1 1];
p3 = [0 1 0 1 0 1 0 1];
t = 0:7;
% Tabla de datos
datos = [p1' p2' p3' t'];
itmax = 10; % Iteración máxima
eit = 0.01;
alpha = 0.3;
N = 8;
W = [0.84 0.39 0.78]; % Pesos
% Inicializamos las matrices auxiliares
Eit = zeros(1, itmax);
valorW = zeros(11, 3);
valorW(1, :) = W;

% Iteraciones desde la primera hasta la máxima
for iteracion = 1:itmax
    for n = 1:N
        p = datos(n, 1:3)';
        disp(p');
        a = purelin(W*p);
        t = datos(n, 4:4);
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