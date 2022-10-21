clc
clear all
close all
Tf = [];
n1f = [];
for i = 750:1200
    T = i ;
    x0 = [10 20];
    aa = fsolve(@(x) myfun(x,T),x0);
    n1 = 100 - aa(1);
    n2 = aa(2)-aa(1);
    n3 = aa(1);
    n4 = aa(1);
    n5 = 100 - aa(2);
    n6 = aa(2);
    Tf(i-749) = i;
    n1f(i-749) = n1;
end
clc
plot(Tf,n1f)
function F = myfun(x,T)
F(1,1) = ((100-x(1))*(x(2)-x(1)))-(0.0247*exp(4020/T)*(x(1))^2);
F(2,1) = (x(2)*(x(2)-x(1)))-((200+x(2))*(100-x(2))*7.28*10^6*exp(-17000/T));
end
