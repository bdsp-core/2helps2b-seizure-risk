clear all; clc; format compact; 

%% play with Andres' data
load CCEMRCDATA

% list variable names
char(data.Properties.VariableNames)

%% 
disp(data(1,:)); % list header -- variable names

