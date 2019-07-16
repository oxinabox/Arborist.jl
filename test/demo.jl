function foo()
    x = 2
    y = bar(x)
    x = bleep()
    return x
end
bar(x) = x
bleep() = boop()
boop() = 7 


function eg1()
    x = 2
    y = eg2()
    return x
end
eg2() = 5