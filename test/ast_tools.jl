using Arborist: wherevar, is_allowable_generated_body
using MacroTools

@testset "wherevar" begin
    @test :T==wherevar(MacroTools.splitdef(:(foo(x::T) where {T} = x))[:whereparams][1])
    @test :T==wherevar(MacroTools.splitdef(:(foo(x::T) where {T<:Int} = x))[:whereparams][1])
end

@testset "is_allowable_generated_body" begin
    @testset "negatives" begin
        @test false == is_allowable_generated_body(
            :(x->2x)
        )

        @test false == is_allowable_generated_body(
            quote
                y=0
                f = () -> y+=1  # NOT ALLOWED, closure
                f()
                return y
            end
        )
        @test false == is_allowable_generated_body(
            quote
                y=sum([1 for ii in 1:3]) ## comprehension
                return y
            end
        )

        @test false == is_allowable_generated_body(
            quote
                global x
                x=5
            end
        )
    end # @testset "negatives"
    
    @testset "positives" begin
        @test true == is_allowable_generated_body(
            :(2x)
        )

        @test true == is_allowable_generated_body(
            quote
                y=0
                f = Base.Fix1(+, y) 
                f()
                return y
            end
        )
        @test true == is_allowable_generated_body(
            quote
                y=sum(identity, 1:3)
                return y
            end
        )
        @test true == is_allowable_generated_body(
            quote
                local x
                x=5
            end
        )
    end  # @testset positities
end
