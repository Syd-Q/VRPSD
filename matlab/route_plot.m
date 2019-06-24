route1=[1 21 20 19];
route2=[1 23 31 24];
route3=[1 25 29 26];
route4=[1 33 39 38 34 32 30];
route5=[1 5 2 4 7 10];
route6=[1 9 8 3 6 13 17];
route7=[1 15 11 12 18];
route8=[1 22 27 16 14];
route9=[1 28 35 37 36];
load data.txt; %从文本文件加载数据
city_xy_ary=data(:,2:3); %得到网点的坐标数据

figure(2)
a=[];
b=[];
for i=1:length(route1(:))
    a=[a city_xy_ary(route1(i),1)];
    b=[b city_xy_ary(route1(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route2(:))
    a=[a city_xy_ary(route2(i),1)];
    b=[b city_xy_ary(route2(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route3(:))
    a=[a city_xy_ary(route3(i),1)];
    b=[b city_xy_ary(route3(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route4(:))
    a=[a city_xy_ary(route4(i),1)];
    b=[b city_xy_ary(route4(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route5(:))
    a=[a city_xy_ary(route5(i),1)];
    b=[b city_xy_ary(route5(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route6(:))
    a=[a city_xy_ary(route6(i),1)];
    b=[b city_xy_ary(route6(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route7(:))
    a=[a city_xy_ary(route7(i),1)];
    b=[b city_xy_ary(route7(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route8(:))
    a=[a city_xy_ary(route8(i),1)];
    b=[b city_xy_ary(route8(i),2)];
end
plot(a,b,'.-');
hold on

a=[];
b=[];
for i=1:length(route9(:))
    a=[a city_xy_ary(route9(i),1)];
    b=[b city_xy_ary(route9(i),2)];
end
plot(a,b,'.-');
hold on
hold off