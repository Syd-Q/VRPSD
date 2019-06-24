%蚂蚁类构造函数

function C=ant()
   
    global CITY_COUNT;

	C.m_dbPathLength=0; %蚂蚁走过的路径长度
	C.m_nCurCityNo=0; %当前所在网点编号
	C.m_nMovedCityCount=0; %已经去过的网点数量

    C.m_nPathAry=zeros(1,CITY_COUNT); %蚂蚁走的路径
	C.m_nAllowedCityAry=zeros(1,CITY_COUNT); %没去过的网点
    
    C=class(C,'ant'); 
    
end
  