function X = process( raw )

%PROCESS Function to process the information into categories

% initialize the output

X = zeros(size(raw));

[N,d] = size(X);

text_col = zeros(1,d);

% find the text columns

for ii = 1:d

    for k = 1:N

        if ischar(cell2mat(raw(k,ii)))

            text_col(ii) = 1;

        end

    end

end

% Add the entries to the matrix

for ii = 1:d

   if text_col(ii)

      % get the text column first

      text = [];

      for k = 1:N

         x = cell2mat(raw(k,ii));

         if ~sum(isnan(x))

             text = [text cellstr(raw(k,ii))];

         else

             text = [text '-'];

         end

      end



      

      % get the unique entries

      Uid = unique(text);

      

      ent = length(Uid);

      % place the element ID in the output

      for k = 1:N

          if strcmp(text(k),' ')

              X(k,ii) = NaN;

          else

              for jj = 1:ent

                 if strcmp(text(k),Uid(jj))

                    X(k,ii) = jj;

                 end

              end

          end

      end

      

   else

      for k = 1:N

         X(k,ii) = cell2mat(raw(k,ii));      

      end    

   end

end





end



