clc
clear all
close all
[kar2019] = xlsread('2019kar.xlsx');
[calisan2019] = xlsread('2019calisan.xlsx');
[kar2021] = xlsread('2021kar.xlsx');
[calisan2021] = xlsread('2021calisan.xlsx');


% calisantoplam2019 = sum(calisan2019)
% calisantoplam2021 = sum(calisan2021)
% rangekar2019 = range(kar2019)
% rangekar2021 = range(kar2021)
% meancalisan2019 = mean(calisan2019)
% meancalisan2021 = mean(calisan2021)
% meankar2019 = mean(kar2019)
% meankar2021 = mean(kar2021)
% maxkar2019 = max(kar2019)
% minkar2019 = min(kar2019)
% max(kar2021)
% min(kar2021)

X = [kar2019;kar2021];
grp = [ones(60,1);2*ones(60,1)];
boxplot(X,grp)
ylabel('Net Sales (TL) ')
xlabel('Years')
set(gca,'XTick',[1 2],'XTickLabel',{'2019','2021'})
grid

binLoc = linspace(0,150000000000,10)
subplot(211)
histogram(kar2019,'BinEdge',binLoc)
grid
title('2019')
ylim([0 60])
ylabel('Number Of Companies')
xlabel('Net Sales (TL) ')
subplot(212)
histogram(kar2021,'BinEdge',binLoc)
grid
title('2021')
ylabel('Number Of Companies')
xlabel('Net Sales (TL)')

X = [calisan2019;calisan2021];
grp = [ones(60,1);2*ones(60,1)];
boxplot(X,grp)
ylabel('Number Of Employment (People)')
xlabel('Years')
set(gca,'XTick',[1 2],'XTickLabel',{'2019','2021'})
grid

binLoc = linspace(0,13000,8)
subplot(211)
histogram(calisan2019,'BinEdge',binLoc)
grid
title('2019')
ylabel('Number Of Companies')
xlabel('Number Of Employment (People)')
subplot(212)
histogram(calisan2021,'BinEdge',binLoc)
grid
ylim([0 20])
title('2021')
ylabel('Number Of Companies')
xlabel('Number Of Employment')