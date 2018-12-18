clear all;
clc;
%T(x,t=0) = sin(pi*x) +sin(3*pi*x)
%T(x=0,t) = T(x=L,t)=0
%Nx=21
%Nt=11
%dx=0.1
%dt=0.01
%D=1

Nx = 21;
Nt = 11;
dx = 0.1;
dt = 0.01;
D = 1;
r = D*dt/(2*dx^2);
x=linspace(0, Nx*dx, Nx);
T_0 = sin(pi*x)+sin(3*pi*x);

A(1:19)=1+2*r;
M1=diag(A);
AU(1:18) = -r;
M2=diag(AU,1);
M3=diag(AU,-1);

M=M1+M2+M3;
b(1:19)=0;
for n=2:Nx-1
    b(n-1)=r*T_0(n-1)+(1-2*r)*T_0(n)+r*T_0(n+1);
end

alpha = M\b';

UL =  0;
UR = 0;

T=[UL, alpha', UR];
history = zeros(Nt,Nx);
history(1,:) =  T_0;
history(2,:) =  T;
for t=3:Nt
  b(1:19)=0;
  for n=2:Nx-1
    b(n-1)=r*T(n-1)+(1-2*r)*T(n)+r*T(n+1);
  end  
  alpha = M\b';
  T=[UL, alpha', UR];
  history(t,:)=T;
end

surf(history)
