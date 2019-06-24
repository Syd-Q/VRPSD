%对结果进行2-OPT优化
function f=opt2(Line)
  
    %数组长度
    size=length(Line);
    
    NewLine=Line; % 返回结果先设置成原来路径
    
    Flag=1;
    
    while (Flag == 1)
        Flag=0;
        
		for i=1:size-2
			a=Line(1,1:i); %路径前段
			b=fliplr(Line(1,i+1:size)); %路径后段倒置        
			c=cat(2,a,b); %新路径       
	        
			%新路径更好就替换
			if (PathLength(c)<PathLength(NewLine))
				NewLine=c;
				Flag=1;
				fprintf('\n======================= 2-OPT 优化成功! ===');
            end
            
        end    
        
    end
           
        
    %返回结果
    f=NewLine;
    
end