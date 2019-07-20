using  Arborist
using Arborist: determine_type_params
using InteractiveUtils
using Test

@testset "determine_type_params" begin
    boop(x::Vector{T}) where {T} = string(T)
    meth = @which boop([1,2,3])
    @test [Int] == collect(determine_type_params(meth, Tuple{Vector{Int}}))

    bing(x::T, y::S) where {S,T} = x+y
    meth = @which bing(1, 1f0)
    @test [Float32, Int64] == collect(determine_type_params(meth, Tuple{Int, Float32}))
end
