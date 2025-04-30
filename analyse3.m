% Charger les valeurs du curseur à partir du fichier
nom_fichier = 'sliders_values.mat';
if isfile(nom_fichier)
    loadedData = load(nom_fichier);
    sliderValues = loadedData.sliderValues;

    % Extraire les valeurs et s'assurer qu'elles sont des nombres entiers si nécessaire
    Nx = int32(round(sliderValues.Nx));
    Ny = int32(round(sliderValues.Ny));
    Nt = int32(round(sliderValues.Nt));   
    rho = sliderValues.rho;
    cp = sliderValues.cp;     
    Lx = sliderValues.Lx;   
    Ly = sliderValues.Ly;
else
    disp('Le fichier de valeurs des sliders n''existe pas.');
    return; % Quitter si le fichier n'existe pas
end
c=1;
C=0.05;

% Discrétisation
dx = double(Lx) / (double(Nx) - 1);
dy = double(Ly) / (double(Ny) - 1);
dt = double(C) * dx / double(c);

% Initialiser le champ de température et la grille spatiale
Tn = zeros(Ny, Nx);
x = linspace(0, double(Lx), double(Nx));
y = linspace(0, double(Ly), double(Ny));
[X, Y] = meshgrid(x, y);

% Définir la matrice de conductivité thermique
k = ones(Ny, Nx);
k(20:25, 30:35) = 0.0001; %Exemple de région avec une conductivité différente

% Température initiale
Tn(:,:) = 0;


% Paramètres de simulation
t = 0;

% Boucle de simulation principale
for n = 1:Nt
    Tc = Tn; % Copier la température actuelle pour les calculs
    t = t + dt;
    
    % Mettre à jour le champ de température
    for i = 2:Nx-1
        for j = 2:Ny-1
            Tn(j, i) = Tc(j, i) + dt * (k(j, i) / (rho * cp)) * ...
                 ((Tc(j,i+1)+Tc(j+1,j)-2*Tc(j,i)+Tc(j-1,i)+Tc(j,i-1))/dx/dx);
        end  
    end 

    % Ajouter une source de chaleur
    Sx = int32(round(7 * double(Nx) / double(Lx)));
    Sy = int32(round(3 * double(Ny) / double(Ly)));
    if t < 5
        Tn(Sy, Sx) = Tn(Sy, Sx) + dt * 100 / (rho * cp);
    end

    %Appliquer des conditions aux limites
    Tn(1, :) = 0;
    Tn(end, :) = 0;
    Tn(:, 1) = 0;
    Tn(:, end) = Tn(:, end-1);

    % Visualisation
    subplot(1, 2, 1);
    mesh(x, y, Tn);
    axis([0 Lx 0 Ly 0 50]);
    xlabel('Distance along the rod');
    ylabel('Temperature');
    title(sprintf('Time = %f seconds', t));

    % Calculer le flux de chaleur
    [Tx, Ty] = gradient(Tn);
    qx = k .* Tx;
    qy = k .* Ty;

    subplot(1, 2, 2);
    imagesc(x, y, Tn);
    set(gca, 'YDir', 'normal');
    hold on;
    quiver(x, y, qx, qy, 'w');
    [sx, sy] = meshgrid(2:2:8, 2:2:8);
    h = streamline(X, Y, qx, qy, sx, sy);
    set(h, 'Color', 'yellow');
    hold off;

    pause(0.01);
end
