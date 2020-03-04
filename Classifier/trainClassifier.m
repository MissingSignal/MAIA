function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData,Kernel,KernelScale,K)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict


%% Extract predictors and response

predictors = trainingData(:,1:end-1);
response = trainingData{:,end};%trainingData.Labels; %%%%%%%%CAMBIATO

%% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', Kernel, ... 
    'PolynomialOrder', [], ...
    'KernelScale', KernelScale, ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', categorical({'AT'; 'PT'})); %{'NEG'; 'POS'}

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = trainingData{:,end}%.Properties.VariableNames; %%%%CAMBIATO
trainedClassifier.ClassificationSVM = classificationSVM;
%trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2019a.';
%trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');


%% Perform cross-validation
%partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold',K);
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'leaveout','on');

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

%Confusion Matrix
for i=1:size(response)
    if response(i) ~= validationPredictions(i)
        fprintf('Failed prediction of ITEM number %d\n',i)
    end
end

figure(1)
cm = confusionchart(categorical(response),validationPredictions,'Normalization','row-normalized');

%ROC
mdlSVM = fitPosterior(classificationSVM);
[~,score_svm] = resubPredict(mdlSVM);

[X,Y,T,AUC] = perfcurve(response,validationScores(:,2),'POS'); 

%[X,Y,T,AUC] = perfcurve(response,score_svm,'POS');
AUC

figure(2)
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC describing A term/Pre term Classification')

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
