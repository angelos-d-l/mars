%close all;
%clear all;

nx=50; %arithmos xwrikwn vhmatwn
nt=30; %arithmos xronikwn vhmatwn
dx=2/(nx-1); %eyros xwrikwn vhmatwn
dt=0.1; %eyros xronikwn vhmatwn
D=0.01; %syntelesths diaxyshs
r=D*dt/(dx^2);
UL=1;
UR=1;
T=zeros(30,50)

for t=2:30
    for i=2:50
        
       T(1,i)= T(1,i-1)+ dx;

        T(t,1)=T(t-1,1)+ dt;
       
    end
end
xx=T(1,:)
tt=T(:,1)
      for i= 1:50
          if T(1,i)>=0.75 && T(1,i)<=1.25
             T(1,i)=2;
            else 
                T(1,i)=1;
          end
      end
      

 figure(1)
 plot(xx,T(1,:))
title('Initial Conditions')
xlabel('Length (m)')
ylabel('Transport property profile (u)')
ylim([0 2.5])

A(1:48)=1+2*r
M1=diag(A)
AU(1:47)= -r
M2=diag(AU,1)
M3=diag(AU,-1)
M=M1+M2+M3
M(1,1)=1+r
M(48,48)=1+r
B=zeros(1,48)

for j=1:29

    B(1,1:48)= T(j,2:49) ;

B(1)= B(1) - (-r)*dx*(-UL);
B(end)=B(end) - (-r)*dx*UR;


AF=M\B'

T(j+1,2:49)=AF;
T(j+1,1)=AF(1,1)+dx*(-UL);
T(j+1,50)=AF(end)+ dx*UR;


end
figure(2)
surf(xx,tt,T)
colorbar
xlabel('Length (m)')
ylabel('Time (s)')
zlabel('Heat')
title('Heat conduction on a bar over time')

figure(4)
plot (xx,T(30,:))
xlabel('Length (m)')
ylabel('Transport property profile (u)')
xlim([0 2])
title('Heat distribution for t=2.9s')