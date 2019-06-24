%蚂蚁类返回属性值函数
function f=get(C,prop_name)

    switch prop_name
        
        case 'path' %得到蚂蚁搜索的路径
            f=C.m_nPathAry;
        
        case 'path_length' %得到蚂蚁搜索的路径长度
            f=C.m_dbPathLength;
        
        otherwise %非法属性，返回错误
            error([prop_name,'不是类的可用属性！']);           
        
end  