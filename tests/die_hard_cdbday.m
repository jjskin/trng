%Jakub Skóra - Birthday Spacings Test - DieHard

clear all;

m = 2^10;
n = 2^24;
n_obs = 500;
lambda = (m^3)/(4*n);

%wczytywanie (random)
%dataBin = randi([0 1], 512000, 32);

%wczytywanie z pliku
%{}
filename = fopen('data.bin');
dataBin = fread(filename,'ubit1');
fclose(filename);
dataBin = reshape(dataBin,32,[])';
%}

for i = 1:9
    for k = 1:n_obs
        %'wycinam' po 24 bity
        for j = 1:m
            index = j + m*(k-1);
            dataCut(j) = bi2de(dataBin(index, i:23+i));
        end

        %sortuje
        dataCut = sort(dataCut);
        
        for j = m:-1:2
            dataDiff(j) = dataCut(j) - dataCut(j-1);
        end
        
        %sortuje
        dataDiff = sort(dataDiff);
        
        %liczanie takich samych ró¿nic
        diff = 0;
        for j = 2:m
            if(dataDiff(j) == dataDiff(j-1)) 
                diff = diff+1;
            end
        end
        diff_count(k) = diff;
    end
    
    %wiêksze ni¿ 1
    diff_count = diff_count(diff_count>1);
    
    %dane do testu
    bins = 0:35;
    pd = makedist('Poisson','lambda', lambda);
    expCounts = n_obs * pdf (pd,bins);
    obsCounts = hist(diff_count,bins);
    
    %test chi2
    [h,p,st] = chi2gof(bins,'Ctrs',bins,...
                        'Frequency',obsCounts, ...
                        'Expected',expCounts,...
                        'NParams',1);   
                    
    p_tab(i) = p;
    
    %histogram
    figure('NumberTitle', 'off', 'Name', ['p-value ', num2str(p) ]);
    
    plot(expCounts);
    hold on
    plot(obsCounts);
    title(p_tab(i));
    hold off
end

%test komogorowa-smirnoffa
uni = makedist('uniform');
[hKS,pKS] = kstest(p_tab, uni);
