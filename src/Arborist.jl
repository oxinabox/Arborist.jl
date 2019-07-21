"""
Arborist.jl
🆒🌳📦
An arborist performs surgery on tree.
"""
module Arborist
using CodeTracking
using Revise: Revise  # Revise must be loaded for CodeTracking to work
using MacroTools

include("reflection.jl")
include("ast_tools.jl")

include("grafters.jl")
# must be last as generate function can't call things defined afteer them
include("core.jl")
end # module
