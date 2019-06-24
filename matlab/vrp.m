%{

[代码说明]
蚁群算法解决VRP问题

[算法说明]
首先实现一个ant蚂蚁类，用此蚂蚁类实现搜索。
算法按照tsp问题去解决，但是在最后计算路径的时候有区别。

比如有10个银行网点,网点1是银行中心，蚂蚁搜索的得到的路径是1,3,5,9,4,10,2,6,8,7。

计算路径的时候把网点依次放入派送线路中,
每放入一个网点前，检查该网点放入后是否会超过运钞车最大载重
如果没有超过就放入
如果超过，就重新开始一条派送路线
……
直到最后一个网点运送完
就会得到多条派送路线


%}

%清除所有变量和类的定义
clear;
clear classes;

%蚁群算法参数(全局变量)
global ALPHA; %启发因子
global BETA; %期望因子
global ANT_COUNT;  %蚂蚁数量
global CITY_COUNT;  %网点数量
global RHO; %信息素残留系数!!!
global IT_COUNT; %迭代次数
global DAry; %两两网点间距离
global TAry; %两两网点间信息素
global CITYWAry; %网点货物需求量
global VW; %运钞车最大载重

%===================================================================

%设置参数变量值
ALPHA=1.0;
BETA=2.0;
RHO=0.95;

IT_COUNT=1000;

VW=100;

%===================================================================
%读取数据并根据读取的数据设置其他参数
load data.txt; %从文本文件加载数据
city_xy_ary=data(:,2:3); %得到网点的坐标数据
CITYWAry=data(:,4); %得到每个网点的资金需求量
x_label=data(:,2); %第二列为横坐标
y_label=data(:,3); %第三列为纵坐标
C=[x_label y_label];      %坐标矩阵

CITY_COUNT=length(CITYWAry); %得到网点数量(包括银行中心在内)
ANT_COUNT=round(CITY_COUNT*2/3)+1; %根据网点数量设置蚂蚁数量,一般设置为网点数量的2/3

%MMAS信息素参数
%计算最大信息素和最小信息素之间的比值
PBest=0.05; %蚂蚁一次搜索找到最优解的概率
temp=PBest^(1/CITY_COUNT);
TRate=(1-temp)/((CITY_COUNT/2-1)*temp); %最大信息素和最小信息素之间的比值

%信息素的最大最小值开始的时候设置成多大无所谓
%第一次搜索完成会生成一个最优解,然后用这个解会重新产生最大最小值
Tmax=1; %信息素最大值
Tmin=Tmax*TRate; %信息素最小值


% 计算两两网点间距离 
DAry=zeros(CITY_COUNT);
for i=1:CITY_COUNT
    for j=1:CITY_COUNT       
       DAry(i,j)=sqrt((city_xy_ary(i,1)-city_xy_ary(j,1))^2+(city_xy_ary(i,2)-city_xy_ary(j,2))^2);
    end
end


% 初始化网点间信息素
TAry=zeros(CITY_COUNT);
TAry=TAry+Tmax;

%===================================================================

%初始化随机种子
rand('state', sum(100*clock));

%另一种方法
%rand('twister',sum(100*clock))

%定义蚂蚁
mayi=ant(); 

Best_Path_Length=10e9; %最佳路径长度，先设置成一个很大的值


tm1=datenum(clock); %记录算法开始执行时的时间

FoundBetter=0; %一次搜索是否有更优解产生


L_best=zeros(IT_COUNT,1);
%开始搜索
for i=1:IT_COUNT    
        
    fprintf('开始第%d次搜索 , 剩余%d次',i,IT_COUNT-i);
    
    FoundBetter=0; %搜索前先置为没有更优解产生
    
    for j=1:ANT_COUNT
        
        %蚂蚁搜索一次
        mayi=Search(mayi); 
        
        %得到蚂蚁搜索路径长度
        Length_Ary(j)=get(mayi,'path_length');
        
        %得到蚂蚁搜索的路径
        Path_Ary{j}=get(mayi,'path');
        
        
        %保存最优解
        if (Length_Ary(j) < Best_Path_Length);
            Best_Path_Length=Length_Ary(j);            
            Best_Path=Path_Ary{j};
            
            %有更优解产生,设置标志
            FoundBetter=1; 
        end        
      %L_best(i)=max(Length_Ary); 
    end
     L_best(i)=Best_Path_Length; 
    %有更好解产生,进行2-OPT优化
    if (FoundBetter == 1)
        fprintf(' , 本次搜索找到更好解!');
        Best_Path=opt2(Best_Path);
        Best_Path_Length=PathLength(Best_Path);
    end    
        
    %-------------------------------------------------------------
    %全部蚂蚁搜索完一次，更新环境信息素
    
    TAry=TAry*RHO;     
    
    %只有全局最优蚂蚁释放信息素
    dbQ=1/Best_Path_Length;                
    for k=2:CITY_COUNT            
        
        m=Best_Path(k-1); %上一个网点编号
        n=Best_Path(k); %下一个网点编号
        
        %更新路径上的信息素
        TAry(m,n)=TAry(m,n)+dbQ; 
        TAry(n,m)=TAry(m,n);
    end
        
    %更新最后网点返回出发网点路径上的信息素
    TAry(n,1)=TAry(n,1)+dbQ; 
    TAry(1,n)=TAry(n,1);
        
    
    %-------------------------------------------------------------
    %更新完信息素,进行边界检查    
    Tmax=1/((1-RHO)*Best_Path_Length); %信息素最大值
    Tmin=Tmax*TRate; %信息素最小值
    
    for m=1:CITY_COUNT
        for n=1:CITY_COUNT
            if (TAry(m,n)>Tmax) 
                TAry(m,n)=Tmax;
            end
            if (TAry(m,n)<Tmin)
                TAry(m,n)=Tmin;                
            end
        end
    end
    
    %-------------------------------------------------------------
    %换行
    fprintf('\n');
       
end

tm2=datenum(clock); %记录算法结束执行时的时间

fprintf('\n搜索完成 , 用时%.3f秒 , 最佳路径长为%.3f , 派送方案如下 :：\n\n[1]',(tm2-tm1)*86400,Best_Path_Length);


%===================================================================
%输出结果
dbW=0;
for i=2:CITY_COUNT
    m=Best_Path(i-1); %上一个网点
    n=Best_Path(i); %当前网点

    if (dbW+CITYWAry(n)>VW) %运送的资金超过限制
        fprintf('          (满载率 : %.1f%%)\n[1]-%d',dbW*100/VW,n);
        dbW=CITYWAry(n);  %运输的资金等于该城市的需求量
    else %没有超过限制
        fprintf('-%d',n);
        dbW=dbW+CITYWAry(n); %运输的资金加上该城市的需求量                
    end                
end
fprintf('          (满载率 : %.1f%%)',dbW*100/VW);

fprintf('\n\n');

%====== [程序结束]=====================================================


figure(1)   %作迭代收敛曲线图
x=linspace(0,IT_COUNT,IT_COUNT);
y=L_best(:,1);
plot(x,y);
xlabel('迭代次数'); ylabel('最短路径长度');










