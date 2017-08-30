function fibonacci
    fprintf('%d', f(20));
end

function result=f(x)
if (x==0)
    result = 0;
else if (x == 1)
    result = 1;
    else
        result=f(x-1) + f(x-2);
    end
end

end