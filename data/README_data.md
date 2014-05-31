## Datafile Readme

# Original Files
winequality-red.csv
winequality-white.csv

These two files are semi colon delimited ';' so using read.csv you would need to define the separater variable.

# True CSV files
winequality-red-new.csv
winequality-white-new.csv

These are true comma-delimited files that have the same data as the two files under "Original files"
should be able to use read.csv without defining 'sep'

# Training & Test sets
*-testset.csv
*-trainingset.csv

These are stratified samples based on the response variable (quality) in a roughly 1/3 (test) - 2/3 (training) ratio.


# white.test.csv
REsults of Regression prediction:
pred.knn  -- k nearest neighbors
pred.lda  -- linear discriminant analysis
pred.mlp -- multilayer perceptron with one hidden layer 
pred.mlpe -- multilayer perceptron ensemble 
pred.randfor -- random forest algorithm 
pred.or -- ordinal regression
pred.svm – support vector machine 

of all of these (run the exact same way using rminer), knn wins with ~60% 