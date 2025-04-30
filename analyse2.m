rho=1.205;
cp=1005;

Lx=10;
Ly=10;
Lz=10;

Nx=21;
Nt=120;
Ny=21;
Nz=21;

dx=Lx/(Nx-1);
dy=Ly/(Ny-1);
dz=Lz/(Nz-1);

c=1;
C=0.05;
dt=C*dx/c;
dt=10;

Tn=zeros(Nx,Ny,Nz);
x=linspace(0,Lx,Nx);
y=linspace(0,Ly,Ny);
z=linspace(0,Lz,Nz);
[X,Y,Z]=meshgrid(x,y,z);

k=ones(Ny,Nx,Nz)+0.0257*100;
k([1 end],:,:)=0.001;
k(:,[1 end],:)=0.001;
k(:,:,[1 end])=0.001;

Tn(:,:,:)=25;
t=0;

for n=1:Nt
    Tc=Tn;
    t=t+dt;
    for i=2:Nx-1
        for j=2:Ny-1
            for l=2:Nz-1
                Tn(i,j,l)=Tc(i,j,l) + ...
                dt*(k(j,i,l)/rho/cp)* ...
                ((Tc(i+1,j,l)-2*Tc(i,j,l)+Tc(i-1,j,l))/dx/dx+ ...
                 (Tc(i,j+1,l)-2*Tc(i,j,l)+Tc(i,j-1,l))/dy/dy+ ...
                 (Tc(i,j,l+1)-2*Tc(i,j,l)+Tc(i,j,l-1))/dz/dz);
            end    
        end  
    end 
    Tbar=mean(Tn(:));

   
    if(t<10*36)
        Tn(10,10,2)=Tn(10,10,2)+dt*1000/rho/cp;
    end

    Tn(1,:,:)=Tn(2,:,:);
    Tn(end,:,:)=Tn(end-1,:,:);
    Tn(:,1,:)=Tn(:,2,:);
    Tn(:,end,:)=Tn(:,end-1,:);
    Tn(:,:,1)=Tn(:,:,2);
    Tn(:,:,end)=Tn(:,:,end-1);

    if (t > 5*36)
        Tn(end,9:11,9:11)=20;
    end 

    if(mod(t , 60)==0)
        clf;
        subplot(2,1,1);
        slice(X,Y,Z,Tn,5,5,2);colorbar;
        axis([0 Lx 0 Ly 0 Lz]);
        title(sprintf('Average Temperature =%.2f Time = %f minutes',Tbar, t/60));
        view(-70,10);

        [Tx,Ty,Tz]=gradient(Tn);
        qx=k.*Tx;
        qy=k.*Ty;
        qz=k.*Tz;

        subplot(2,1,2);
        streamslice(X,Y,Z,qx,qy,qz,9,9,9,0.1);
        axis([0 Lx 0 Ly 0 Lz]);
        hold on;
        [sx,sy,sz]=meshgrid([2 5 8], [2 5 8] ,[2 5 8]);
        h=streamline(X,Y,Z,qx,qy,qz,sx,sy,sz);
        set(h, 'color','red');
        hold off;
        view(-70,10);

        pause(0.01);
    end    
end