%蚂蚁类搜索函数
function C=Search(C)
  
    %=======================================================
    %全局变量
    global ALPHA; %启发因子
    global BETA; %期望因子
    global CITY_COUNT;  %网点数量
    global DAry; %两两网点间距离
    global TAry; %两两网点间信息素
    global CITYWAry; %网点货物需求量
    global VW; %车辆最大载重

    %========================================================
    %以下定义嵌套子函数实现蚂蚁完成一次搜索路径
    
    %初始化
    function f1=Init()
        
    	C.m_dbPathLength=0; %蚂蚁走过的路径长度清0
        C.m_nPathAry=C.m_nPathAry*0;  %清空蚂蚁走的路径
        C.m_nAllowedCityAry=C.m_nAllowedCityAry+1; %把全部网点设置为没有去过              
        
        C.m_nPathAry(1)=1; %从网点1出发，也就是配送站
        C.m_nCurCityNo=1; %开始所在的网点是配送站
        C.m_nMovedCityCount=1; %已经去过的网点数量为1
        C.m_nAllowedCityAry(1)=0; %第一个网点设置为去过了

        f1=0;    
    end

    %========================================================

    %蚂蚁选择下一个网点
    function f2=ChooseNextCity()
        nSelectedCity=-1; %蚂蚁选择出的下一个网点，暂时设置成-1
        
        dbTotal=0; 

        %计算各个网点被选中的概率值
    	for i=1:CITY_COUNT
    		if (C.m_nAllowedCityAry(i) == 1) %网点没去过

                %该网点和当前网点间的信息素
        		prob(i)=(TAry(C.m_nCurCityNo,i)^ALPHA)/(DAry(C.m_nCurCityNo,i)^BETA);
            	
                %累加信息素，得到总和
                dbTotal=dbTotal+prob(i); 

            else
                
                %如果网点去过了，则其被选中的概率值为0
        		prob(i)=0.0;
            end           
        end



        %开始进行轮盘选择
        dbTemp=0.0;
    	if (dbTotal > 0.0) %总的信息素值大于0
            
        	dbTemp=rand*dbTotal; %取一个随机数
            
            for i=1:CITY_COUNT
                
                if (C.m_nAllowedCityAry(i) == 1) %网点没去过	
                    
                    dbTemp=dbTemp-prob(i); %这个操作相当于转动轮盘
                    
    				if (dbTemp < 0.0) %轮盘停止转动，记下网点编号，直接跳出循环	
                        
        				nSelectedCity=i;
            			break;
                        
                    end
                    
                end
                
            end                
            
        end        
        
        
    	%如果网点间的信息素非常小 ( 小到比double能够表示的最小的数字还要小 )    
        %那么由于浮点运算的误差原因，上面计算的概率总和可能为0
    	%会出现经过上述操作，没有网点被选择出来
    	%出现这种情况，就把第一个没去过的网点作为返回结果
    	if (nSelectedCity == -1)
        	for i=1:CITY_COUNT
            	if (C.m_nAllowedCityAry(i) == 1) %网点没去过
                	nSelectedCity=i;
                    break;
                end            
            end            
        end                            
    
        %返回
        f2=nSelectedCity;
        
    end
    
    %========================================================

    %蚂蚁在网点间移动
    function f3=Move()
        
        nCityNo=ChooseNextCity(); %选择下一个网点

        C.m_nMovedCityCount=C.m_nMovedCityCount+1; %已经去过的网点数量加1
    	C.m_nPathAry(C.m_nMovedCityCount)=nCityNo; %保存蚂蚁走的路径
        C.m_nAllowedCityAry(nCityNo)=0;%把这个网点设置成已经去过了
    	C.m_nCurCityNo=nCityNo; %改变当前所在网点为选择的网点
    
        
        f3=0;
    end
    %========================================================
    
    %计算蚂蚁走的路径长度
    function f4=CalPathLength()       

        n=0;
        m=0;
        dbW=0; %保存到达某网点运送的货物量
        
    	C.m_dbPathLength=0.0; %先把路径长度置0

        for i=2:CITY_COUNT
            m=C.m_nPathAry(i-1); %上一个网点
            n=C.m_nPathAry(i); %当前网点

            if (dbW+CITYWAry(n)>VW) %运送的货物超过限制
                C.m_dbPathLength=C.m_dbPathLength+DAry(m,1); %返回配送站的距离
                C.m_dbPathLength=C.m_dbPathLength+DAry(1,n); %车辆从配送站重新出发
                dbW=CITYWAry(n);  %运输的重量等于该网点的需求量          
            else %没有超过限制
                C.m_dbPathLength=C.m_dbPathLength+DAry(m,n); %从上一个网点到该网点的距离
                dbW=dbW+CITYWAry(n); %运输的重量加上该网点的需求量                
            end                
        end

        C.m_dbPathLength=C.m_dbPathLength+DAry(n,1); %加上从最后网点返回配送站的距离      
    
        f4=0;
    end


    
    %========================================================
    %蚂蚁进行搜索
    
    Init();
    
	%如果蚂蚁去过的网点数量小于网点数量，就继续移动
    while (C.m_nMovedCityCount < CITY_COUNT)
        Move();
    end


	%完成搜索后计算走过的路径长度
	CalPathLength();    
    
    %========================================================
    %搜索结束
    
end
