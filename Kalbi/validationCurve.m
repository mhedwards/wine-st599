function [lambda_vec, error_train, error_val] = ...
    validationCurve(Xtrain_N, Ytrain, Xcv_N, Ycv)
%VALIDATIONCURVE Generate the train and validation errors needed to
%plot a validation curve that we can use to select lambda
%   [lambda_vec, error_train, error_val] = ...
%       VALIDATIONCURVE(X, y, Xval, yval) returns the train
%       and validation errors (in error_train, error_val)
%       for different values of lambda. You are given the training set (X,
%       y) and validation set (Xval, yval).
%
 %0.001 0.003 0.03
% Selected values of lambda (you should not change this)
%lambda_vec = [0 0.0005 0.001 0.003 .008 0.01 0.03 0.05 0.1 0.3 .5 1 1.5 2];% 4 6 8 10]';
lambda_vec = [0 .05 .08 .1 .3 .5 .7 1 1.5 2 2.5 3 3.5  4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 10 ]';
%lambda_vec = [0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 7 8 9 10]';
 num_labels = 10;
% You need to return these variables correctly.
error_train = zeros(length(lambda_vec), num_labels);
error_val = zeros(length(lambda_vec), num_labels);
m = size(Xtrain_N,1);
% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return training errors in 
%               error_train and the validation errors in error_val. The 
%               vector lambda_vec contains the different lambda parameters 
%               to use for each calculation of the errors, i.e, 
%               error_train(i), and error_val(i) should give 
%               you the errors obtained after training with 
%               lambda = lambda_vec(i)
%
% Note: You can loop over lambda_vec with the following:
%
%       for i = 1:length(lambda_vec)
%           lambda = lambda_vec(i);
%           % Compute train / val errors when training linear 
%           % regression with regularization parameter lambda
%           % You should store the result in error_train(i)
%           % and error_val(i)
%           ....
%           
%       end
%
%
%a =zeros(10,1);
 for k = 1:length(lambda_vec),
     lambda = lambda_vec(k);
     theta = OneVsAll(Xtrain_N, Ytrain,num_labels, lambda);
     for c = 1:num_labels,
         theta_c = theta(c,:);
         ytrain = (Ytrain==c);
         ycv  = (Ycv==c);
          error_train(k,c) = OneVsAllCostFunction(theta_c, Xtrain_N,ytrain ,  num_labels ,lambda) ;    %%modify
          error_val(k,c) = OneVsAllCostFunction(theta_c,Xcv_N, ycv, num_labels,lambda);  %%modify
          %a =  OneVsAllCostFunction(theta_c, Xtrain_N,ytrain ,  num_labels ,lambda) ;    %%modify
          %error_val = OneVsAllCostFunction(theta_c,Xcv_N, ycv, num_labels,lambda);  %%modify
     end
     %error_train(k) = sum(a);
     %error_train(k,:) = sum(error_train,2);
     %error_val(k,:)  = sum(error_val,2);
 
 end
     
 error_train = sum(error_train,2)
 error_val  = sum(error_val,2)
 
 %sum(error_val,2)
 
 
 
 
 
% =========================================================================
 
end

