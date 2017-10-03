% Creadondo arrays
 a = [1 2 3 4 5];
 a2 = [1, 2, 3, 4, 5]; % Es lo mismo que arriba
 b = 1:5; % Es lo mismo que arriba, no es necesario poner []
 b2 = 5:-0.5:-1; % inicio:paso:final
 c = linspace(0, 2, 10); % crea 10 numeros entre 0 y 2
 d = [a a2]; % Concatenamos a y a2 en un nuevo arreglo
 e = a(1); % Nos devuelve el valor de esa posicion como un nuevo array
 e2 = a(1:2); % Array de la posicion 1 a la 2
 e3 = a([1 3 5]); % Obtenemos las posiciones 1, 3 y 5
 a(10) = 777; % Ponemos el 777 en la posicion 10 y rellenamos con 0s
 f = [1 2 3; 4:6]; % Vector de dos filas por dos 3 columnas
 f2 = f'; % La transpuesta de f
 f3 = [1 0 2
     5 78 9]; % Otra forma de especificar una matriz
 g = round(rand(3, 5)*10); % matriz de 3 * 5 de numeros entro 0 y 10
 g2 = zeros(4, 5); % Matriz 4*5 de ceros;
 g3 = ones(10*3); % Matriz 10*3
 h = [1:5; 2:6];
 h(1:2, 4:5); %Acedemos a los elementos de la matriz
 h(2, :) = 3:7; % remplazamos una fila
 size(h); % Devuelve las dimensiones mxn
 length(h) % Devuelve columnas o filas (el valor más grande)
 numel(h) % Total de elementos
 h(end, end); % end se refiere a la ultima fila/columna segun sea el caso
 a(2) = []; % Elimina el elmento de la posicion 2
 
 % Funciones vergas
 factorial(7);
 sum([1 2 3]); % Alv eso de iterar con un for
 sum([1:3; 4:6]) % Suma columnas
 % Lo mismo ocurre si usamos prod() producto
 min([777 1 5 90 42]) % Encuentra el minimo, tambien existe max()
 % Un super for con un while y un if
 for variable=1:5
     disp(variable);
     while variable > 0
         variable = variable -1;
         if variable == 0
            disp('Es cero');
         elseif variable > 0
            disp('Continua...')
         end
     end
     
 end
 
 % Operaciones chidas con matrices
 a = [1:5; 2:6];
 b = a * 2; % Multiplica cada elmemento por dos (tambien funciona con el resto de operaciones)
 % Para la potencia usamos .^
 % Para operaciones entre matrices termino a termino .^ .* ./
 % Las operaciones logicas se hacen sobre los elementos del vector
 % Para matrices utilizamos | y & (no dobles)
 