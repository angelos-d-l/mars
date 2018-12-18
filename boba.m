alpha=25;
kappa=2*10^7;
T_rad=1;
tau_0=100;
rho=100;
tc=100;
m=1000;
n=101;
%T(r,t=0)=300K
%T(rho,t)=UR=300K Dirilecht
%dT(0,t)/dr=UL=0 Neumann

T=zeros(m,n);
T(:,1)=300;
T(m,:)=300;

a=
