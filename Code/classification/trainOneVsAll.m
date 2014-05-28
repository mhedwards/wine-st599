function [theta] = trainOneVsAll(X, y,num_labels, lambda)
%trainOneVsAll Trains One vs All log regression given a dataset (X, y) , number f labels and a
%regularization parameter lambda, return trained parameters thetas
% Initialize Theta
initial_theta = zeros(size(X, 2), 1); 
 
% Create "short hand" for the cost function to be minimized
costFunction = @(t) OneVsAll(X, y, num_labels, t, lambda);
 
% Now, costFunction is a function that takes in only one argument
options = optimset('MaxIter', 200, 'GradObj', 'on');
 
% Minimize using fmincg
theta = fmincg(costFunction, initial_theta, options);
 
end
