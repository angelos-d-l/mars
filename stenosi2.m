clc
clear all;

%γ =- 2(α+β)
nx = 100;
ny = 150;
L=2; 
dx = 2/(nx-1);
dy = 2/(ny-1);
a = 1/dx^2;
b = 1/dy^2;
g = -2*(a+b);

Main_g(1:nx-2) = g;
dg = diag(Main_g);
Main_a(1:nx-3) = a;
da1 = diag(Main_a,1);
da2 = diag(Main_a,-1);

M1 = dg + da1 + da2;

Main_b(1:nx-2) = b;
M2 = diag(Main_b);
K1=kron(eye(ny-2),M1);




