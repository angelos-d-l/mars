clc
clear all;
alpha=25; % 25cm ακτίνα ράβσου
kappa=2*10^7; % cm^2/year Συντελεστής διάχυσης
T_rod=1; % 1K Αρχική μεταβολή θερμοκρασίας ράβδου
tau_0=100; % years Χρόνος ημιζωής
rc=100; % cm Συνολική απόσταση
tc=100; % years Συνολικός χρόνος
m=1000; % Σύνολο χρονικών βημάτων
n=101; % Σύνολο χωρικών βημάτων
%T(r,t=0)=300K
%T(rc,t)=UR=300K Dirilecht
%dT(r=0,t)/dr=UL=0 Neumann
dt = tc/(m-1);
dx = rc/(n-1);
x = linspace(0, n*dx, n);
s = kappa * dt/dx^2
T=zeros(m,n);
T(1,:)=300;
T(:,n)=300;

A(n-2) = 1+2*s;
A(1) = 1+s+s/2;
M1=diag(A);



