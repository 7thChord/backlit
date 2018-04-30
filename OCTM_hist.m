function T = OCTM_hist(H,u)

%d=3;                %所允许的最大色调失真
d=u;

% A1=zeros(256,256);
% for i=1:256
%     A1(i:256,i)=1;
% end
% b=255*ones(1,256);
%z=GetOCTMBound(Image_in,0.1);    
lb=1/d*ones(256,1);     %s的下界向量，其中ceil可以把频率为0灰度级的s的下界设为0，不为0的下界为1/d
ub=u*ones(256,1);   %s的上界向量，根据不同要求取不同值
                    %若无权重，一般取1.5~2；若有权重，一般取3~4.
[s,G]=linprog(-H,ones(1,256),256,[],[],lb,ub);   %求解s的最优解
G=-G;               %求解的最小值，实际是最大值
T=cumsum(s)+0.5;    %根据最优解s求出最优转移函数T
T=floor(T);         %整数化，因为是整数映射
T(1)=1;