function List = LocNhieu(List)
% Nhận vào list vị trí các khung có giá trị local peak lớn hơn ngưỡng
% Trả ra mảng gồm 0 và 1. 0 tại vị trí khoảng lặng, 1 tại vị trí nguyên âm. 
N = length(List);
% Lọc ra các trường hợp làm nhiễu.
for i=2:N-1
    if(List(i-1)==0 && List(i)==1 && List(i+1)==0) 
        List(i)=0;
    end
    if(List(i-1)==1 && List(i)==0 && List(i+1)==1)
        List(i)=1;
    end
     if(List(i-1)==0 && List(i)==1 && List(i+1)==1 && List(i+2)==0)
        List(i)=0;
        List(i+1)=0;
    end
end
end
