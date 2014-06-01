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
X = data(:,1:11);
  
m = size(X, 1);
%y = randi(10,1,m)';    %randomly generate m  integers between 1 and 10

%splitting data into 3 sets
rand_indices = randperm(m);  %randomly suffle the rows
ntrain = round(m*.6)-1;
ncv = round(m*.2);
ntest = round(m*.2);
%training set
Xtrain = X(rand_indices(1:ntrain), :); 
Ytrain = Y(rand_indices(1:ntrain), :); 

%Cross validation set
Xcv = X(rand_indices(ntrain+1:ntrain+ncv), :);
Ycv = Y(rand_indices(ntrain+1:ntrain+ncv), :);

%test set
Xtest = X(rand_indices(ntrain+ncv+1:end), :);
Ytest = Y(rand_indices(ntrain+ncv+1:end), :);


%%learning curve
%lambda=0;
%m=50;
%[error_train, error_val] = ...
%    learningCurve(Xtrain(1:m,:), Ytrain(1:m), Xcv(1:m,:), Ycv(1:m), lambda);
%plot(1:m, error_train, 1:m, error_val);


%%normalizing features and polymial mapping
p = 8;
X_ptrain = [Xtrain,Xtrain.^2,Xtrain.^3,Xtrain.^4];%polyFeatures(Xtrain, p);            % mappin into p degree poly
[X_ptrainN, mu, sigma] = featureNormalize(X_ptrain);  % normalizing

X_pcv = [Xcv,Xcv.^2,Xcv.^3,Xcv.^4];%polyFeatures(Xcv, p);            % mappin into p degree poly
[X_pcvN, mu, sigma] = featureNormalize(X_pcv);  % normalizing

X_ptest =[Xtest,Xtest.^2,Xtest.^3,Xtest.^4]; % polyFeatures(Xtest, p);            % mappin into p degree poly
[X_ptestN, mu, sigma] = featureNormalize(X_ptest);  % normalizing

%% trainning OneVsAll Logistic%%%%%

num_labels = 10;
fprintf('\nTraining One-vs-All Logistic Regression...\n')
 
%%Validation for Selecting best Lambda value=============

num_labels = 10;
[lambda_vec, error_train, error_val] = ...
    validationCurve(X_ptrainN, Ytrain, X_pcvN, Ycv);
 
close all;


plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');
 title('Validation curve');
 fprintf('lambda\t\tTrain Error\tValidation Error\n');
for i = 1:length(lambda_vec)
    fprintf(' %f\t%f\t%f\n', ...
            lambda_vec(i), sum(error_train(i,:)), error_val(i));
end
 
fprintf('Program paused. Press enter to continue.\n');
pause;


%% = Predict for One-Vs-All ================
%  After ...


lambda = .5;       %54.38
[theta_best] = OneVsAll(X_ptrainN, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, X_ptestN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100);

%saving prediction
D = [pred Ytest];
csvwrite('preictionVstrueVal.dat',D);

pred = predictOneVsAll(theta_best, X_ptrainN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100); %56.02



%%
lambda = 0.05; 
[theta_best] = OneVsAll(X_ptrainN, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, X_ptestN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100); %54.59

pred = predictOneVsAll(theta_best, X_ptrainN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100); %56

%
lambda = 1.5; %53.87
[theta_best] = OneVsAll(X_ptrainN, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, X_ptestN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100); %53.67

pred = predictOneVsAll(theta_best, X_ptrainN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100); %55.85

 
%%%
lambda = 4.5; %53.87
[theta_best] = OneVsAll(X_ptrainN, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, X_ptestN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100); %54.48

pred = predictOneVsAll(theta_best, X_ptrainN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100); %56

lambda = .6; %53.87
[theta_best] = OneVsAll(X_ptrainN, Ytrain, num_labels, lambda);
 
fprintf('Program paused. Press enter to continue.\n');
pause;

pred = predictOneVsAll(theta_best, X_ptestN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTest Set Accuracy: %f\n', mean(double(pred == Ytest)) * 100); %54.48

pred = predictOneVsAll(theta_best, X_ptrainN);  %%thetas corrrespond to best lambda 
 
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Ytrain)) * 100); %56
