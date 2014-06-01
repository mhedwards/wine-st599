function [J] = OneVsAllCostFunction(theta, X, y, num_labels, lambda)

%%computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters.
m = length(y); % number of training examples
 num_labels = 10;
% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));
%Y = zeros(m,num_labels);
%for c = 1:10
 %   Y(:,c) = (y == c)
%end
%Y;
X = [ones(m, 1) X];
n=size(X,2);
%J = zeros(num_labels);
%for c = 1:num_labels
    %theta_c = theta(c,:);
j =(-1/m)*(log(sigmoid(X*theta'))'*y+log(1-sigmoid(X*theta'))'*(1-y));
 pel = lambda/(2*m)*(sum(theta(1,[2:n]).^2));
 
 J =j+ pel; 
 
grad=(1/m)*(X)'*(sigmoid(X*theta')-y)+(lambda/m)*[0,theta(1,[2:n])]';
%end

J   %= J(:)

grad = grad(:);

end


