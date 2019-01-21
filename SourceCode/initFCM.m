function V = initFCM(X,c,type)

%INITFCM Function to initialize the centres of FCM

d = length(X(1,:)); %dimension of the incomplete given dataset

switch type 

    case 'zeros'

        % centres at origin

        V = zeros(c,d);

    case 'random'

        % centres at random

        V = rand(c,d);

    case 'gaussian'

        %gaussian with zero mean and 1 variance

        V = normrnd(0,1,c,d);

    case 'sample'

        % choose centres with random vectors

        d = length(X(:,1));

        for i =1:c

            idx = randperm(d,1);

            V(i,:) = X(idx,:);

        end
end

end



