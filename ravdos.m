clc;
clear all;

Nx = 10;
Nt = 100;
tf =0.4;
dx = (1-0)/(Nx-1);
dt = (tf-0)/(Nt-1);

u=zeros(Nx, Nt);
x(1) = 0;
for len=2:10
    x(len) = x(len-1) + dx;
end

u(:,1) = sin(pi*x);
u(1,:) = 0;
u(10,:) = 0;

for j=1:Nt
    for i=2:9
        u(i,j+1) = u(i,j) + (dt/dx^2)*(u(i+1,j)-2*u(i,j)+u(i-1,j));
    end
end

[X,Y] = meshgrid(0:0.004:0.4,0:0.1111:1);
surf(X, Y, u)
colorbar
