function X = reconstruct(X,Ui,m,V)
%RECONSTRUCT Function to reconstruct the data
% inputs:
% X - data vector
% Ui - partition entry value
% V - centres
% m - fuzzifier index
% outputs:
% X - reconstructed data point

d = length(X);  % dimension of the vector
c = length(V(:,1)); % number of classes / clusters

for ii = 1:d

    if isnan(X(ii)) % if its a missing value
       X(ii) =  0; 
       den = 0;
       for j = 1:c
          X(ii) = X(ii) + (Ui(j)^m)*V(j,ii); 
          den = den + (Ui(j)^m);
       end
       if den>0
         X(ii) = X(ii)/den;
       end
    end
    if isnan(X(ii))
        X(ii) =0;
    end
end

end

