%Jakub Skóra
%Analiza Ÿród³a entropi - histogram, entropia

var = 1;
for a = 1:1:50
    %Wczytywanie zdjêcia
    filename = ['photo/' num2str(a) '.jpg'];
    photo = imread(filename);
    photo = imresize(photo ,[512 512]);

   for t = 1:1:512
       for x = 1:1:512
        input(var) = photo(t,x);
        var = var+1;
       end
   end
 
end

%-------------------------------------------------------------------------%
%histogram i entropia
histogram(input,'Normalization','probability');
title('Empiryczny rozk³ad zmiennych losowych generowanych przez Ÿród³o szumu');
xlabel('Wartoœci (x)')
ylabel('Czêstoœæ wystêpowania (p)');

entropia = entropy(input);
display(entropia);

