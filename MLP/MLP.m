%% Funcion principal
function MLP()
%     archivo_datos = input('Ingrese el nombre del archivo de datos: ', 's');
%     archivo_targets = input('Ingrese el nombre del archivo de targets: ', 's');
%     rango_entrada = input('Ingrese el nombre del archivo de targets: ', 's');
      rango = [-2 2];
      puntos1 = -2 + (0-(-2)) * rand(100, 1);
      puntos2 = 0 + (2-(0)) * rand(100, 1);
      puntos = [puntos1 puntos2];
      puntos = sort(puntos);
      
      targets = zeros(160, 1);
      targets_x = zeros(160, 1);
      prueba = zeros(40, 1);
      prueba_x = zeros(40, 1);
      j = 1;
      k = 1;
      puntos_y = 1 + sin(6*pi*puntos/4);
      for i = 1:200
          if mod(i, 5) == 0
              prueba_x(j) = puntos(i);
              prueba(j) = 1 + sin(6 * pi * puntos(i)/4);
              j = j+1;
          else
              targets_x(k) = puntos(i);
              targets(k) = 1 + sin(6 * pi * puntos(i)/4);
              k = k+1;
          end
      end
      %targets = 1+sin(8*pi*puntos/4);
%     arqui_entrada = input('Ingrese el vector de la arquitectura: ', 's');
      arquitectura = [1 2 1];
%     funciones_entrada = input('Ingrese el vector de funciones de la arquitectura: ', 's');
%     alpha = input('Ingrese el factor de aprendizaje (alpha): ');
      alpha = 0.05;
%     itmax = input('Ingrese el numero maximo de iteraciones: ');
      itmax = 5000;
%     Eit = input('Ingrese el error de entrenamiento de una iteracion: ');
%     itval = input('Ingrese el intervalo de validacion: ');
%     num_val = input('Ingrese el numero de incrementos consecutivos: ');
%     division = input('Elija si dividir 1) 80-10-10 o 2) 70-15-15: ');
      [W, b] = inicializar(arquitectura);
      Fn = zeros(arquitectura(2));
      for iteracion = 1:itmax
          for i = 1:160
            p = targets_x(i);
            a1 = logsig(W{1} * p + b{1});
            a2 = purelin(W{2} * a1 + b{2});
            e = targets(i) - a2;
            s2 = -2*(1)*e;
            for j = 1:arquitectura(2)
                Fn(j, j) = (1-a1(j))*a1(j);
            end
            s1 = Fn*W{2}'*s2;
            
            W{2} = W{2} - alpha*s2*a1';
            b{2} = b{2} - alpha*s2;
            
            W{1} = W{1} - alpha*s1*p';
            b{1} = b{1} - alpha*s1;
          end
      end
      salida = zeros(1, 40);
      for i = 1:40
          p = prueba_x(i);
          a1 = logsig(W{1} * p + b{1});
          a2 = purelin(W{2} * a1 + b{2});
          salida(i) = a2;
      end
      figure;
      plot(targets_x', targets');
      hold;
      grid;
      plot(prueba_x', salida);
      xlabel('p');
      ylabel('g(p)');
      legend('g(p)', 'MLP');
      title('Para [1 2 1]')
end

function [W, b] = inicializar(arqui)
    capas = length(arqui) - 1;
    b = cell([1 capas]);
    W = cell([1 capas]);
    for i = 1:capas
        S = arqui(i+1);
        R = arqui(i);
        W{i} = -1 + (1-(-1)) * rand(S, R);
        b{i} = rand(S, 1);
    end
end