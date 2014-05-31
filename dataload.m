
%loading data 
cd 'E:\wine-st599'
 B=importdata('wine.csv');   %this is an object with 3 elements data, colhead, textdata
data=B.data;      %to get our data
%x1=data(:,1);    %fixed acidity
%x2=data(:,2);    %volatile acidity
%x3=data(:,3);    %citric acid
%x4=data(:,4);    %residual sugar
%x5=data(:,5);    %chlorides
%x6=data(:,6);    %free sulfur
%x7=data(:,7);    %total sulfur
%x8=data(:,8);    %density
%x9=data(:,9);    %PH
%x10=data(:,10);   %sulphates
%x11=data(:,11);   %alcohol
Y = data(:,12);    %quality
x = data(:,1:11);
%X = [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11];   %predictors
X = [x, x.^2, x.^3, x.^4];
    
    