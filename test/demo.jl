function foo()
    x = 2
    y = bar(x)
    return x
end
bar(x) = x


function eg1()
    x = 2
    y = eg2()
    return x
end
eg2() = 5