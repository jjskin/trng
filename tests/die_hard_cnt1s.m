%Jakub Skóra - Count the ones Test - DieHard

clear all;
no_wds = 256000;
letter = 'AABCDEEE'; 

%wczytywanie z pliku
%{}
filename = fopen('data.bin');
dataBin = fread(filename,'ubit1');
fclose(filename);
%troche "toporne" rozdzielenie danych
dataBin1 = dataBin(1:no_wds*4*8);
dataBin1 = reshape(dataBin1,[],8);
dataBin2 = dataBin(no_wds*4*8+1:16384000);
dataBin2 = reshape(dataBin2,[],8);
dataBin = dataBin1;
%}

%dla kodu orgianlnego pV = 24
for pV = 1:2
    
    %wczytywanie (random)
    %dataBin = randi([0 1], no_wds*4, 8);

    %zliczanie 1 - zamiana na litery
    for i = 1 : no_wds*4
        let = nnz(dataBin(i, :));
        if(let == 0)
           letters(i) = letter(1);
        else
           letters(i) = letter(let);
        end
    end

    %zamiana na 4 i 5 literowe
    letters_4 = reshape(letters,4,no_wds)';

    index = 1;
    for i = 1:no_wds
        for j = 1:5
            letters_5(i,j) = letters(index);
            index = index + 1;
        end
        index = index - 4;
    end

    %zliczenie iloœci wystêpowania danych s³ów
    [~, ~, ic] = unique(letters_4, 'rows');   
    occurrence_4 = accumarray(ic,1);
    occurrence_4 = occurrence_4';

    [~, ~, ic] = unique(letters_5, 'rows');   
    occurrence_5 = accumarray(ic,1);
    occurrence_5 = occurrence_5';

    %obliczanie wartoœci oczekiwanej
    wdspos_4 = 5^4;
    wdspos_5 = 5^5;
    prob = [37/256 56/256 70/256 56/256 37/256];

    for k=0:wdspos_4-1
          Ef = no_wds;
          wd = k;
          for l=1:4
            ltr = mod(wd,5)+1;
            Ef = Ef*prob(ltr);
            wd = floor( wd/5);
          end
         expected_4(k+1)=Ef;
    end

    for k=0:wdspos_5-1
          Ef = no_wds;
          wd = k;
          for l=1:5 
            ltr = mod(wd,5)+1;
            Ef = Ef*prob(ltr);
            wd = floor( wd/5);
          end
         expected_5(k+1)=Ef;
    end

    %wystepowanie
    %{}
    figure
    plot(occurrence_4);
    title("4");

    figure
    plot(occurrence_5);
    title("5");
    %}

    %Roznicy sum Pearsona 
    Q4 = sum(((occurrence_4 - expected_4).^2) ./ expected_4);
    Q5 = sum(((occurrence_5 - expected_5).^2) ./ expected_5);

    d_Q5Q4 = Q5 - Q4;
    z =(d_Q5Q4 - 2500) / sqrt(5000);
    p(pV) = 1 - normcdf(z);
    
    %wyczytanie z pliku
    dataBin = dataBin2;
end