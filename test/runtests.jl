using Arborist
using Test

@testset "Arborist.jl" begin
    test_files = (
        "ast_tools.jl",
        "reflection.jl",
    )
    @testset "$file" for file in test_files
        include(file)
    end
end
