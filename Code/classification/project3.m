%%project3
%loading data 
cd 'E:\wine-st599'
 B=importdata('wine.csv');   %this is an object with 3 elements                  %                             %data, colhead, textdata

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
%x = data(:,1:11);
%x = [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11];   %predictors

%mu = mean(x);
%sigma = std(x);

X = data(:,1:11);

%X = [x, x.^2, x.^3, x.^4]; % 4 degree polynomial
%hist(Y);
    
m = size(X, 1);
y = randi(10,1,m)';    %randomly generate m  integers between 1 and 10

%splitting data into 3 sets
rand_indices = randperm(m);  %randomly suffle the rows
ntrain = round(m*.6)-1;
ncv = round(m*.2);
ntest = round(m*.2);
Xtrain = X(rand_indices(1:ntrain), :); 
ytrain = y(rand_indices(1:ntrain), :); 
Ytrain = Y(rand_indices(1:ntrain), :); 

Xcv = X(rand_indices(ntrain+1:ntrain+ncv), :);
ycv = y(rand_indices(ntrain+1:ntrain+ncv), :);
Ycv = Y(rand_indices(ntrain+1:ntrain+ncv), :);

Xtest = X(rand_indices(ntrain+ncv+1:end), :);
ytest = y(rand_indices(ntrain+ncv+1:end), :);
Ytest = Y(rand_indices(ntrain+ncv+1:end), :);

%%normalizing features
Xtrain_N = featureNormalize(Xtrain);
Xcv_N = featureNormalize(Xcv);
Xtest_N = featureNormalize(Xtest);

%% trainning OneVsAll Logistic%%%%%

num_labels = 10;
fprintf('\nTraining One-vs-All Logistic Regression...\n')
 
%%Validation for Selecting best Lambda value=============

 num_labels = 10;
[lambda_vec, error_train, error_val] = ...
    validationCurve(Xtrain_N, ytrain, Xcv_N, ycv);
 
close all;

num_labels = 10;
[lambda_vec, error_train, error_val] = ...
    validationCurve(Xtrain_N, Ytrain, Xcv_N, Ycv);
 
close all;


plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');
 
fprintf('lambda\t\tTrain Error\tValidation Error\n');
for i = 1:length(lambda_vec)
    fprintf(' %f\t%f\t%f\n', ...
            lambda_vec(i), error_train(i), error_val(i));
end
 
fprintf('Program paused. Press enter to continue.\n');
pause;


%% = Predict for One-Vs-All ================
%  After ...

lambda = 1;
[theta_best] = OneVsAll(Xtrain_N, ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, Xtest_N);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == ytest)) * 100);
 

  pred = predictOneVsAll(theta_best, Xtrain_N);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == ytrain)) * 100);
 


lambda = 2.5;
[theta_best] = OneVsAll(Xtrain_N, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, Xtest_N);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100);
 

pred = predictOneVsAll(theta_best, Xtrain_N);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100);
 

