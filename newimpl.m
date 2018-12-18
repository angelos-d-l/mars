clc
clear all;
Nx=50;
Nt = 30;
dx = 2/(Nx-1);
dt = 0.1;
D = 0.01;
x=linspace(0, Nx*dx, Nx);
T_0(1:Nx) = 1;

for cur=1:Nx
    if x(cur) >= 0.75 && x(cur) <= 1.25
        T_0(cur) = 2;
    end
end
%%Neuman
beta = D*dt/(dx^2);
A(1:Nx-2)=1+2*beta;
A(1) = 1+ beta;
A(Nx-2) = 1 + beta;
M1=diag(A);
AU(1:Nx-3) = -beta;
M2=diag(AU,1);
M3=diag(AU,-1);
M=M1+M2+M3;

% %b(1:Nx-2)=0;
% for n=2:Nx-1
%     b(n-1)=T_0(n);
% end

 UL=1;
 UR=1;
T=T_0;
for t=2:Nt
   
    b=T(2:end-1);
    b(1) = b(1)-(-beta)*dx*(-UL); 
    b(end) =b(end)-(-beta)*dx*UR;
    alpha = M\b';
    T1 = alpha(1)+dx*(-UL);
    TN = alpha(end)+dx*UR;
    %T=[T1, alpha', TN];    
    T(2:end-1)=alpha;
    T(1)=T1;
    T(end)=TN;


end

%surf(history2)

plot(T)