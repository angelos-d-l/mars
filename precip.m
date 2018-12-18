P = [0.00 0.07 1.11 0.00 0.00 0.00 0.00 0.04 0.02 0.05 0.34 0.06 0.18 0.02 0.02 0.00 0.00 0.00 0.00 0.45 0.00 0.00 0.70 0.00 0.00 0.00 0.00 0.00 0.01 0.03 0.05];

T = (P > 0);
e12=0;
n00 =0;
n11 =0;
n10 = 0;
n01 =0;
for i=1:length(T)-1
    if T(i)==0 && T(i+1)==0
        e12 = e12+1;
    end  
    if T(i)==0 && T(i+1)==0
        n00 = n00+1;
    end      
    if T(i)==1 && T(i+1)==1
        n11 = n11+1;
    end  
    if T(i)==0 && T(i+1)==1
        n01 = n01+1;
    end 
    if T(i)==1 && T(i+1)==0
        n10 = n10+1;
    end     
end

e2=30-sum(T(1:length(T)-1));
pe2=e2/length(T);

pe12=e12/length(T);

pr=pe12/pe2;
p00=n00/(length(T)-1);
p01=n01/(length(T)-1);
p11=n11/(length(T)-1);
p10=n10/(length(T)-1);

n0d=n01+n00;
nd0=n00+n10;
n1d=n10+n11;
nd1=n01+n11;

e00=n0d*nd0/(length(T)-1);
e01=n0d*nd1/(length(T)-1);
e10=n1d*nd0/(length(T)-1);
e11=n1d*nd1/(length(T)-1);




for i=1:length(T)
a=rand();
if T(i) == 0 
if a>p01 
    disp("rain")
    Forecast(i)="rain";
else
    disp("sunny")
    Forecast(i)="sunny";
end
end

if T(i) == 1 
if a>p11 
    disp("rain")
    Forecast(i)="rain";
else
    disp("sunny")
    Forecast(i)="sunny";
end
end

end

