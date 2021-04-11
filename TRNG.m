%Jakub Skóra
%True random number generation from mobile telephone photo based on chaotic cryptography

var = 1;
for a = 1:1:50
    %Wczytywanie zdjêcia
    filename = ['photo/' num2str(a) '.jpg'];
    photo = imread(filename);
    photo = imresize(photo ,[512 512]);

    %Skala szaroœci
    photo = rgb2gray(photo);

    %Algorytm Floyda-Steinberga - redukcja palety barwnej lub tonalnej
    photo = Floyd_Steinberg_Dithering(photo);   

    %Arnold Cat Map - chaotic map
    photo = arnold_cat_map(photo);

    %Podzia³ na 16 384 bloków i liczba czarnych pikseli
    %Parzysta = 0 | Nieparzysta = 1
    x = 1;
    y = 1;
    for i = 1:4:512-3
        for j = 1:4:512-3
            cell = photo((i:i+3),(j:j+3));
             if (mod(sum(sum(cell)),2) == 0)
                T(x,y) = 0;
             else
                T(x,y) = 1;
             end
             y = y+1;
        end
        y = 1;
        x = x+1;
    end

    %ZigZag
    post = ZigZagscan(T);  
    
    %Suma
    for t = 1:1:16384
        all(1,var) = post(1,t);
        var = var+1;
    end
    
    %Liczba przetworzonych - command window
    display(a);
end

%-------------------------------------------------------------------------%
%102400 x 8bit
all8b = reshape(all,[8,102400]);
all8b = all8b';

%-------------------------------------------------------------------------%
%bin2dec
for i = 1:1:102400
    dec(i)= bi2de(all8b(i,:),'right-msb');
end

%-------------------------------------------------------------------------%
%histogram i entropia
dec_normalized = dec/max(abs(dec));
histogram(dec,256,'Normalization','probability');
title('Empiryczny rozk³ad zmiennych losowych po post-processingu');
xlabel('Wartoœci (x)')
ylabel('Czêstoœæ wystêpowania (p)');
ylim([0 0.006])
entropia = entropy(dec_normalized);
display(entropia);

%-------------------------------------------------------------------------%
%zapis do bin
file = fopen('data.bin','w');
fwrite(file,all,'ubit1');
fclose(file);
