function f=PathLength(Path)
    
    %全局变量
    global DAry; %两两网点间距离
    global CITYWAry; %网点资金需求量
    global VW; %车辆最大资金额
    
    %=====================================================
    n=0;
    m=0;
    dbW=0; %保存到达某网点运送的货物量        
    Len=0; %先把路径长度置0        
    COUNT=length(Path);%数组长度
    
    for i=2:COUNT
        m=Path(i-1); %上一个网点
        n=Path(i); %当前网点

        if (dbW+CITYWAry(n)>VW) %运送的资金超过限制
            Len=Len+DAry(m,1); %返回配送站的距离
            Len=Len+DAry(1,n); %车辆从配送站重新出发
            dbW=CITYWAry(n);  %运输的资金等于该城市的需求量          
        else %没有超过限制
            Len=Len+DAry(m,n); %从上一个网点到该网点的距离
            dbW=dbW+CITYWAry(n); %运输的重量加上该网点的需求量                
        end                
    end

    Len=Len+DAry(n,1); %加上从最后网点返回配送站的距离      

    f=Len;
    
end
