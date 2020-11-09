clc;clear;
predecesores = [1 2 3 4 4  4 5 6 6  7 8  9 10 11 11 12 13 14 15];
actividades =  [2 3 4 5 6 10 8 7 9 11 9 14 11 12 13 15 15 16 16];
duraciones =   [0 2 4 10 6 4 5 7 9 7 8 4 5 2 6 0];
nombres = {'COMIENZO' 'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'FIN'};
G = digraph(predecesores,actividades,[],nombres);

[nodos,~] = size(G.Nodes);
[arcos,~] = size(G.Edges);

tempranos = zeros(nodos,2);
for i = 1:nodos
    nodo = G.Nodes(i,1).Variables;
    
    dependecias = [];
    for j = 1:arcos
        arco = G.Edges(j,1).Variables;
        es_dependencia = strcmpi(arco(2),nodo);
        if es_dependencia == 1
            dependecias = [dependecias; arco(1)];
        end
    end
    
    indices = zeros(1,length(dependecias));
    for j = 1:length(dependecias)
        for k = 1:nodos
            nodo_ = G.Nodes(k,1).Variables;
            if strcmpi(nodo_,dependecias(j)) == 1
                indices(j) = k;
            end
        end
    end
    if i==1
        tempranos(i,:) = [0 0];
    else
        comienzo = max(tempranos(indices,2));
        terminacion = comienzo + duraciones(i);
        tempranos(i,:) = [comienzo,terminacion]; 
    end
end

tardios = zeros(nodos,2);
for i = 1:nodos
    nodo = G.Nodes(nodos-i+1,1).Variables;
    predecesores = [];
    for j = 1:arcos
        arco = G.Edges(j,1).Variables;
        es_predecesor = strcmpi(arco(1),nodo);
        if es_predecesor == 1
            predecesores = [predecesores; arco(2)];
        end
    end
    
    indices = zeros(1,length(predecesores));
    for j = 1:length(predecesores)
        for k = 1:nodos
            nodo_ = G.Nodes(k,1).Variables;
            if strcmpi(nodo_,predecesores(j)) == 1
                indices(j) = k;
            end
        end
    end
    
    if i==1
        tardios(nodos-i+1,:) = tempranos(nodos-i+1,:);
    else
        terminacion = min(tardios(indices,1));
        comienzo = terminacion - duraciones(nodos-i+1);
        tardios(nodos-i+1,:) = [comienzo,terminacion]; 
    end
end

holguras = tardios - tempranos;
ruta_critica = G.Nodes(holguras(:,1)==0,1).Variables;

[~,n] = size(nombres);
nombres_ = zeros(1,n) + "";

for i=1:n
    nombres_(i) = nombres(i);
end

comienzo_y_final = [nombres_(1) nombres_(end)];
etiquetas = nombres_ + " (" + duraciones + ")";

for i=1:length(etiquetas)
    s = " " + tempranos(i,1) + "," + tempranos(i,2) + "; ";
    s = s + tardios(i,1) + "," + tardios(i,2) + "";
    etiquetas(i) = etiquetas(i) + " " + s;
end

p = plot(G,'NodeLabel',etiquetas,'ArrowSize',20,'LineWidth',5,...
    'NodeFontSize',18,'NodeFontWeight','bold','NodeColor', 'k');
view(-90,-90);
highlight(p, ruta_critica, 'EdgeColor','red');
highlight(p, comienzo_y_final, 'NodeColor', 'red', 'MarkerSize', 6);

T = table(nombres_(2:end-1)',holguras(2:end-1,1),holguras(2:end-1,1)==0,'VariableNames',{'Actividad', 'Holgura', 'Ruta Crítica'});
disp(T);

optimista = [1 2 6 4 1 4 5 5 3 3 4 1 1 5]';
probable  = [2 3.5 9 5.5 4.5 4 6.5 8 7.5 9 4 5.5 2 5.5]';
pesimista = [3 8 18 10 5 10 11 17 9 9 4 7 3 9]';
media = (optimista+(4*probable)+pesimista)/6;
varianza = ((pesimista-optimista)/6).^2;
duraciones = [0; media; 0];

T = table(nombres_(2:end-1)',optimista,probable,pesimista,media,varianza,'VariableNames',{'Actividad','Optimista','Probable','Pesimista','Media','Varianza'});
disp(T);

tempranos = zeros(nodos,2);
for i = 1:nodos
    nodo = G.Nodes(i,1).Variables;
    
    dependecias = [];
    for j = 1:arcos
        arco = G.Edges(j,1).Variables;
        es_dependencia = strcmpi(arco(2),nodo);
        if es_dependencia == 1
            dependecias = [dependecias; arco(1)];
        end
    end
    
    indices = zeros(1,length(dependecias));
    for j = 1:length(dependecias)
        for k = 1:nodos
            nodo_ = G.Nodes(k,1).Variables;
            if strcmpi(nodo_,dependecias(j)) == 1
                indices(j) = k;
            end
        end
    end
    if i==1
        tempranos(i,:) = [0 0];
    else
        comienzo = max(tempranos(indices,2));
        terminacion = comienzo + duraciones(i);
        tempranos(i,:) = [comienzo,terminacion]; 
    end
end

tardios = zeros(nodos,2);
for i = 1:nodos
    nodo = G.Nodes(nodos-i+1,1).Variables;
    predecesores = [];
    for j = 1:arcos
        arco = G.Edges(j,1).Variables;
        es_predecesor = strcmpi(arco(1),nodo);
        if es_predecesor == 1
            predecesores = [predecesores; arco(2)];
        end
    end
    
    indices = zeros(1,length(predecesores));
    for j = 1:length(predecesores)
        for k = 1:nodos
            nodo_ = G.Nodes(k,1).Variables;
            if strcmpi(nodo_,predecesores(j)) == 1
                indices(j) = k;
            end
        end
    end
    
    if i==1
        tardios(nodos-i+1,:) = tempranos(nodos-i+1,:);
    else
        terminacion = min(tardios(indices,1));
        comienzo = terminacion - duraciones(nodos-i+1);
        tardios(nodos-i+1,:) = [comienzo,terminacion]; 
    end
end

holguras = tardios - tempranos;
ruta_critica = G.Nodes(holguras(:,1)==0,1).Variables;

nombres_ = nombres_(holguras(:,1)==0);
nombres_ = [nombres_(2:end-1)';"Duración del proyecto"];
media_critica = media(holguras(2:end-1,1)==0);
media_critica = [media_critica; sum(media_critica)];
varianza_critica = varianza(holguras(2:end-1,1)==0);
varianza_critica = [varianza_critica; sum(varianza_critica)];

T = table(nombres_,media_critica,varianza_critica,...
    'VariableNames',{'Actividades de la Ruta Crítica Media','Media','Varianza'});
disp(T);

deadline = 47;
m = media_critica(end);
sd = sqrt(varianza_critica(end));
Ka = (deadline - m)/ sd;
probabilidad = cdf(makedist('Normal'),Ka);

T = table(deadline,m,sd,Ka,round(probabilidad,2),'VariableNames',{'Deadline','Media','Desviación Estándar','K_alpha','Probabilidad de cumplir el deadline'});
disp(T);