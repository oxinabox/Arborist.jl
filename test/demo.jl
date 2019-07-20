function eg1()
    x = 2
    y = eg1a(x)
    x = eg1b()
    return x
end
eg1a(x) = x
eg1b() = eg1c()
eg1c() = 7 


function eg2()
    x = 2
    y = eg2()
    return x
end
eg3() = 5