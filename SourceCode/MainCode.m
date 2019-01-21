clear
close all
clc
warning off

%step(1): Read the excel file and Calculate number of instances and attributes 

[fname,path] = uigetfile('*.xlsx','Select the file with the missing data');

fname = strcat(path,fname);  

% calculate the dimensions of the data

[~,~,raw] = xlsread(fname);  % get both the numerical and text data 
[X]= process(raw);

X1 = X;  % save copy of incomplete data

Imptd=[]; % variable to store imputed data values

Orig =[]; % variable to store original data values

[N,~] = size(X);

% remove unnecessary NaN

i1 = 1;

while(i1<=length(X(1,:)))

  if sum(isnan(X(:,i1)))==N

      X(:,i1) =[];

  else

      i1=i1+1;

  end

end

[~,d] = size(X);

fprintf('Data has %d Instances and %d Features \n', N, d);

%step(2): Finding missing value positions

X_proc = [];   %initialize processed X variable

miss_val = []; %initialize missing value variable

for i1 = 1:N

    if sum(isnan(X(i1,:)))>0

        fprintf('\n Missing Data indices found in %d Instance: ',i1);

        for jj = 1:d

            if isnan(X(i1,jj))

                fprintf('%d ',jj);

            end

        end

        miss_val = [miss_val i1];

    else

        X_proc = [X_proc; X(i1,:)];

    end

end

Var_X = var(X_proc); % calculate the variance of existing data without missing values

%Step(3): Get the Partition Matrix and cluster centroids through Fuzzy C-Means Clustering

m = 1.75; % fuzzification coefficient

nc = 10;   % Number of clusters

[U,V] = fcm(X,nc,1.75,Var_X);

%Step(4): Reconstruction process of the missing data

l = length(miss_val);  % total number of missing data entries

for i1 = 1:l

    fprintf('\nData Instance %d Before reconstruction',miss_val(i1));

    X(miss_val(i1),:)

    % reconstruct data points

    X(miss_val(i1),:) = reconstruct(X(miss_val(i1),:),U(:,miss_val(i1)),m, V);

    fprintf('After Reconstruction');

    Imptd=[Imptd X(miss_val(i1),:)];

    X(miss_val(i1),:)

end

%step(4): Calculate NRMS, AE, Get the original file path and Imputed data
%file path

[fname,path] = uigetfile('*.xlsx','Select the original data file');

fname = strcat(path,fname);

[~,~,raw] = xlsread(fname);

[X_orig]= process(raw);

% remove unnecessary NaN

i1 = 1;

while(i1<=length(X_orig(1,:)))

  if sum(isnan(X_orig(:,i1)))==N

      X_orig(:,i1) =[];

  else

      i1=i1+1;

  end

end

NRMS = [];

AE =[];

for i1 = 1:length(miss_val)

    for j = 1:d

        X_pr = X(miss_val(i1),j)/max(X(:,j));  % normalization of imputed value

        X_og = X_orig(miss_val(i1),j)/max(X(:,j)); % normalization of original value
%         C_N= X(miss_val(i1),j);
%         XC_pr = Categories(C_N);
        
        Orig = [Orig X_og*max(X(:,j))];

        NRMS = [NRMS sqrt((sum((X_pr -X_og).^2))/d)];

        AE = [AE abs(X_pr -X_og)];

    end

end

% exclude missing data with values as zeros

Imptd(NRMS==0)=[];

Orig(NRMS==0)=[];

AE(NRMS==0) = [];

NRMS(NRMS==0) = [];

fprintf('\n\nThe NRMS value is %4.4f',mean(NRMS));

fprintf('\nThe average error is %4.4f',mean(AE));

% store the output in excel file

fpath = uigetdir(pwd,'Select the folder to store the imputed file');

fname = strcat(fpath,'\Imputed.xlsx');

delete(fname);

xlswrite(fname,X1,'Incomplete Data');

xlswrite(fname,X,'Imputed Data');

xlswrite(fname,X_orig,'Original Data');

xlswrite(fname,Imptd,'Imputed values');

xlswrite(fname,Orig,'Original values');

xlswrite(fname,NRMS,'NRMS');

k=length(NRMS)+2;

xlswrite(fname,cellstr('mean NRMS'),'NRMS',sprintf('A%d:A%d',k,k));

xlswrite(fname,mean(NRMS),'NRMS',sprintf('A%d:A%d',k+1,k+1));

xlswrite(fname,AE','AE');

k=length(AE)+2;

xlswrite(fname,cellstr('mean AE'),'AE',sprintf('A%d:A%d',k,k));

xlswrite(fname,mean(AE),'AE',sprintf('A%d:A%d',k+1,k+1));

% plot Missing Data points and NRMS 

figure(1)

bar(NRMS);

title('Normalized Root Mean Square Error');

xlabel('Missing Data Points');

ylabel('NRMS');






