clc;
clear all;
n=21;
A=0.5;
D=0.05;
L=2;
dt=0.05;
u=1;
l=1;
dx=L/n;
y=zeros(21, 30);
k=2*pi/l;
x(1) = 0;
for len=2:21
    x(len) = x(len-1) + dx;
end
y(:,1) = A*sin(k*x);
for t=2:30
    for i=1:21
        if i == 21
           y(i,t) = y(i,t-1)-(1/2)*(u*dt/dx)*(y(i,t-1)-y(i-1,t-1))+D*(dt/dx^2)*(y(i,t-1)-2*y(i,t-1)+y(i-1,t-1)); 
        end
        if  i == 1
            y(i,t) = y(i,t-1)-(1/2)*(u*dt/dx)*(y(i+1,t-1)-y(i+1,t-1))+D*(dt/dx^2)*(y(i+1,t-1)-2*y(i,t-1)+y(i+1,t-1));
        end
        if i>1 && i<21
            y(i,t) = y(i,t-1)-(1/2)*(u*dt/dx)*(y(i+1,t-1)-y(i-1,t-1))+D*(dt/dx^2)*(y(i+1,t-1)-2*y(i,t-1)+y(i-1,t-1));
        end
    end
end
T=0.1;
f = exp(-D*k^2*T)*A*sin(k*(x-u*T));
figure(1);
plot(x,y(:,2),x,f)
T=0.5;
f = exp(-D*k^2*T)*A*sin(k*(x-u*T));
figure(2);
plot(x,y(:,10),x,f)
