clc
clear all
close all

N = normrnd(50,15,60,5)
G = N(:,1).*0.25+N(:,2).*0.25+N(:,3).*0.1+N(:,4).*0.1+N(:,5).*0.3
mean_G = mean(G)
population_deviation = std(G,1,1)
L = checkgrade(mean_G,population_deviation,G)

