%%
%Sample Grid LCOE costs evaluation, based on K. Branker, M. J.M. Pathak, J. M. Pearce, “A Review of Solar Photovoltaic Levelized Cost of Electricity”,
 %Renewable & Sustainable Energy Reviews 15, pp.4470-4482 (2011).
 
%http://dx.doi.org/10.1016/j.rser.2011.07.104

%%
clc
Irate=0.04; %Interest Rate [%]
r=0.03; %Discount Rate
S=6000; %Yearly rated energy output [kWh]
d=0.005; %Degradation Rate [%]
T=30; %Life of the project, in years
I=zeros(T,1);
I(1,1)= 12000; %Initial investment cost [$]
O=260;%Yearly Operations Cost [$]
M=50; %Yearly Maintaincen Cost [$]
%Interest expenditures
    F=zeros(T,1); 
    for i=1:30
        F(i,1)=Irate*I(1,1);
    end


LCOE=zeros(1);
NUM=zeros(1);
DEN=zeros(1);

 i=1; 
        for j=1:T
            NUM(1,i)=NUM(1,i)+((I(j,i)+O+M+F(j,i))/(1+r)^j);
            DEN(1,i)=DEN(1,i)+((S*(1-d)^j)/(1+r)^j);
        end
    LCOE(1,i)=NUM(1,i)/DEN(1,i);

   fprintf('\n The LCOE Costs for given inputs is $ %0.2f \n',LCOE)
