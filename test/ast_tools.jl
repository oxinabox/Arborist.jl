using Arborist: wherevar
using MacroTools

@testset "wherevar" begin
    @test :T==wherevar(MacroTools.splitdef(:(foo(x::T) where {T} = x))[:whereparams][1])
    @test :T==wherevar(MacroTools.splitdef(:(foo(x::T) where {T<:Int} = x))[:whereparams][1])
end
