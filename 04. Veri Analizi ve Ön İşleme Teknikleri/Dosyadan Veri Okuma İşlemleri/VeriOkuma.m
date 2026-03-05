clc;
clear;
close all;

filename = 'VeriSeti.xlsx';
veriTablosu = readtable(filename);

veriTablosu.Properties.VariableNames = {'Basınç', 'Nem', 'Sıcaklık', 'HavaDurumu', 'Yoğunluk'};

disp("Okuma işlemi tamamlandı.");
head(veriTablosu,10);

[satirSayisi, sutunSayisi] = size(veriTablosu);
fprintf("Verimiz %d satir ve %d sutundan olusmaktadir.", satirSayisi, sutunSayisi);