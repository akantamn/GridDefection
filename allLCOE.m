%%
% Support files for "Quantifying Potential for Solar Hybrid Technology Enabled Grid Defection in Rural America"

%Paper Authors: Abhilash Kantamneni, Richelle Winkler, Lucia Gauchia, Joshua M. Pearce

%Code Author: Abhilash Kantamneni.

%% Initialize Data


load('AnnualConsumption.mat')
load('PvSystemSize.mat')
load('AnnualCHPGeneration.mat')
DailyConsumption=AnnualConsumption/365; 
StorageSize=DailyConsumption/2; %Size a battery to last 12 hours [kWh]
PVCostProj=[3.5;2.9;2.5;2.1;1.8;1.5]; %Declining PV costs [$/kW]
StoragCostProj=[621;507;414;338;275;225];%Declining storage costs [$/kWh]
CHPCostProj=ones(6,1)*1400; %CHP costs remain same, since tech is mature [$/kWe]
NatGasCostProj=ones(6,1)*0.9; %Short term gas costs remain same [$/Therm]
CHPOpCost=ones(6,1)*0.08; %Operating costs constant due to constant gas costs [$/Therm]
Irate=0.0499;% Max interest rate available through Michigan Saves

%% LCOE Calculation
%Calculation based on K. Branker, M.J.M. Pathak, J.M. Pearce,
% A Review of Solar Photovoltaic Levelized Cost of Electricity,
%Renewable and Sustainable Energy Reviews, 15, pp.4470-4482 (2011).
for y=1:6
    AnnualOpCost=CHPOpCost(y,1)*AnnualCHPGeneration;
    for R=1:8 % 8 UP utilities
        for C=1:8 % Family households
            T=30; %LCOE study term in years
            P=10; %Loan period
            I=zeros(T,1);
            I(1,1)=PVSystemSize(R,C)*PVCostProj(y,1)*1000 + ...
                StorageSize(R,C)*2*StoragCostProj(y,1) + ....
                2*CHPCostProj(y,1); %Initial investment PV+Storage+CHP
            UpFront(y,R,C)=PVSystemSize(R,C)*PVCostProj(y,1)*1000 + ...
                StorageSize(R,C)*StoragCostProj(y,1) + ....
                CHPCostProj(y,1);
            O=ones(T,1);
            O(1,1)=AnnualOpCost(R,C);
            F=zeros(T,1); 
    for i=1:P
        if I(1,1)<30000
            F(i,1)=Irate*I(1,1); 
        else
            F(i,1)=Irate*30000; %Assuming rest in downpayment
        end
    end
    
    r=0.03; %discount rate for t [%]
    S=AnnualConsumption(R,C); %Yearly Rated Energy Output
    d=0.005; %Degradation Rate [%]
    
    NUM=0;
    DEN=0;
    for j=1:T
        O(j,1)=O(j,1)*1.02; %Operational costs increase with inflation
        
        NUM=NUM+((I(j,1)+O(j,1)+F(j,1))/(1+r)^j);
        DEN=DEN+((S*(1-d)^j)/(1+r)^j);
        
    end
    
    LCOE(y,R,C)=NUM/DEN;
	
    end
    end

end

%% Save results in Table
LRowNames={'Alger Delta';'Cloverland';'Xcel';'Municipal'; ...
'OCREA';'UPPCO';'WE';'WPSC'};
LColNames={'Seasonal' 'TotalCustomers' 'pHH1' 'pHH2' 'pHH3'  ...
    'pHH4' 'pHH5' 'pHH6'};

Year2015=array2table(reshape(LCOE(1,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);
Year2016=array2table(reshape(LCOE(2,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);
Year2017=array2table(reshape(LCOE(3,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);
Year2018=array2table(reshape(LCOE(4,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);
Year2019=array2table(reshape(LCOE(5,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);
Year2020=array2table(reshape(LCOE(6,:,:),8,8), ...
    'RowNames',LRowNames,'VariableNames',LColNames);

%% Print Results

writetable(Year2015,'2015_LCOE.csv','Delimiter',',','WriteRowNames',true)
writetable(Year2016,'2016_LCOE.csv','Delimiter',',','WriteRowNames',true)
writetable(Year2017,'2017_LCOE.csv','Delimiter',',','WriteRowNames',true)
writetable(Year2018,'2018_LCOE.csv','Delimiter',',','WriteRowNames',true)
writetable(Year2019,'2019_LCOE.csv','Delimiter',',','WriteRowNames',true)
writetable(Year2020,'2020_LCOE.csv','Delimiter',',','WriteRowNames',true)


%% Clear all
clear all
clc
