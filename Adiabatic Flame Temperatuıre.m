clc
clear all
close all

% mmp: methane molar percentage
% emp: ethane molar percentage
% eap: excess air percentage
% constants_m: a b c d values of methane
% constants_e: a b c d values of ethane
% constants_o: a b c d values of oxygen
% constants_n: a b c d values of nitrogen
% constants_co2: a b c d values of co2
% constants_h20: a b c d values of h2o

temps=[26 26 220 220];
H=[-75.00 -83.75 0 0];

K=ones(1,11);
L=[0:10];

format shortG 
mmp_a=K.*L.*0.1;
emp_a=1-mmp_a;
eap_b=K(2:5).*L(2:5).*0.1;

% ------------------------------------------------------------
% calculations of H values
% dH= int[Cp(T)dt]
% Cp= a + bT + c T^2 + d T^3


constants_m= [34.31 5.469 0.3661 -11.00];
constants_e= [49.37 13.92 -5.816 7.280];
constants_o=[29.10 1.158 -0.6076 1.311];
constants_n=[29.00 0.2199 0.5723 -2.871];
constants_co2=[36.11 4.233 -2.887 7.464];
constants_h2o=[33.46 0.688 0.7604 -3.593];
constants=[constants_m; constants_e; constants_o; constants_n; constants_co2; constants_h2o];   
parameters= [10^(-3) 10^(-5) 10^(-8) 10^(-12)];

syms x 
dH=[];
T_constants=[1 x x^2 x^3];
i=1;
Cp_eqn= constants(i).*parameters.*T_constants;
for i=1:4
    Cp=sum(constants(i).*parameters.*T_constants);
    dH_i=int(Cp,25,temps(i));
    dH(i)=dH_i;
    H(i)=H(i)+dH(i);
end

dH;
H;
% a

mo=(2.*mmp_a+(7/2).*emp_a).*1.4;
mn=3.76*mo;

H_input=[H(1)*mmp_a'+H(2)*emp_a'+H(3)*mo'+H(4)*mn'];
% H_input is the matrix of the total enthalpies of the feed's compononents with respect to CH4 mole fraction
comb_e= -1559.9;
comb_m= -890.36;
hofc=[comb_m*mmp_a'+comb_e*emp_a'];
% hofc is the matrix of the total enthalpies of heat of combustion with respect to CH4 mole fraction

RS=H_input-hofc;
%rs is the right side of equation

mco2=mmp_a'+2*emp_a';
mh2o=2*mmp_a'+3*emp_a';
mo2=(2.*mmp_a+(7/2).*emp_a)'.*0.4;
% mole fraction of products

syms x

hco2=sum(constants_o.*parameters.*T_constants)*mo2;
hcn=sum(constants_n.*parameters.*T_constants)*mn';
hcco2=sum(constants_co2.*parameters.*T_constants)*mco2;
hch2o=sum(constants_h2o.*parameters.*T_constants)*mh2o;
hcf=hco2+hcn+hcco2+hch2o;
% heat capacities of products

Hvap_su=40.656*mh2o;
% Hvap_su is the matrix of the total enthalpies of vaporization of water with respect to CH4 mole fraction

% Hvap_su + int(hcf,25,T)-RS==0;

a=[];

for i=1:11
    knownvalue1=RS-Hvap_su;
    fun1 = matlabFunction(hcf(i),'vars',x);
    T_guess_1=1500;
    Tflame_1= fzero(@(Tf) integral(fun1,25,Tf) - (knownvalue1(i)), T_guess_1);
    a(i)=Tflame_1;
end

a;

A=[100*mmp_a' a'];

a_cevap=array2table(A,'VariableNames',{'Mole % CH4 (40% excess air)', 'Flame T (°C)'});

a_cevap = table(a_cevap,'VariableNames',{'Table 1.Project Results (a)'})
% ----------------------------------------------------------
% ----------------------------------------------------------
% b


hB=0.5*H(1:2);

z=ones(4,2);
y=z(:,1).*hB;

oksijenmol=(2.*0.5+(7/2).*0.5)*(1+eap_b);
nitrojenmol=oksijenmol*3.76;
GIRENENTALPI=[y(1)+y(2)+H(3)*oksijenmol'+H(4)*nitrojenmol'];
% entahlpies of feed

yanma=comb_m*0.5 + comb_e*0.5;
% enthalpy of heat of combustion


RS2=GIRENENTALPI-yanma;
bmco2=0.5+2*0.5;
bmh2o=2*0.5+3*0.5;
bmo2=(2*0.5+(7/2)*0.5)'.*eap_b;
% mole of fraction of products



bhco2=sum(constants_o.*parameters.*T_constants)*bmo2';
bhcn=sum(constants_n.*parameters.*T_constants)*nitrojenmol';
bhcco2=sum(constants_co2.*parameters.*T_constants)*bmco2;
bhch2o=sum(constants_h2o.*parameters.*T_constants)*bmh2o;
bhcf=bhch2o+bhcn+bhcco2+bhco2;
% heat capacities of products

vapsu=40.656*bmh2o;
% enthalpy of vaporization of water 

% eqn2=vapsu+int(bhcf,25,T2)-RS2;
% general equation

b=[];

for i=1:4
    knownvalue2=RS2-vapsu;
    fun = matlabFunction(bhcf(i), 'vars', x);
    UB_guess=1500;
    Tflame_2= fzero(@(Tf) integral(fun, 25, Tf) - (knownvalue2(i)), UB_guess);
    b(i)=Tflame_2;
end

b;

B=[1*eap_b' b'];

b_cevap = array2table(B,'VariableNames',{'% excess air (50% CH4)','Flame T (°C)'});

b_cevap = table(b_cevap,'VariableNames',{'Table 2.Project Results (b)'})




% Kayra Kağan Balcı - Eren Eser