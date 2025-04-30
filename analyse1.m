rho=1;
cp=1;
Lx=10;
Ly=10;
Nx=51;
Nt=100;
Ny=51;
dx=Lx/(Nx-1);
dy=Ly/(Ny-1);
c=1;
C=0.05;
dt=C*dx/c;
Tn=zeros(Nx,Ny);
x=linspace(0,Lx,Nx);
y=linspace(0,Ly,Ny);
[X,Y]=meshgrid(x,y);
k=ones(Ny,Nx);
k(20:25,30:35)=0.0001;
Tn(:,:)=0;
t=0;
for n=1:Nt
    Tc=Tn;
    t=t+dt;
    for i=2:Nx-1
        for j=2:Ny-1
            Tn(j,i)=Tc(j,i) +...
                dt*(k(j,i)/rho/cp)*...
                ((Tc(j,i+1)+Tc(j+1,j)-2*Tc(j,i)+Tc(j-1,i)+Tc(j,i-1))/dx/dx);
        end  
    end 
    Sx=round(7*Nx/Lx);
    Sy=round(3*Ny/Ly);
    if(t<5)
        Tn(Sy,Sx)=Tn(Sy,Sx)+dt*100/rho/cp;
    end
    Tn(1,:)=0;
    Tn(end,:)=0;
    Tn(:,1)=0;
    Tn(:,end)=Tn(:,end-1);
    subplot(1,2,1);
    mesh(x,y,Tn);axis([0 Lx 0 Ly 0 50]);
    xlabel('Distance along the rod'); ylabel('Temperature');
    title(sprintf('Time = %f seconds', t));

    [Tx,Ty]=gradient(Tn);
    qx=k.*Tx;
    qy=k.*Ty;

    subplot(1,2,2);
    imagesc(x,y,Tn);
    set(gca, 'ydir', 'norm');
    hold on;
    quiver(x,y,qx,qy,'w');
    [sx,sy]=meshgrid(2:2:8,2:2:8);
    h=streamline(X,Y,qx,qy,sx,sy);
    set(h, 'color','yellow');

    hold off;

    pause(0.01);
end