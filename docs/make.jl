using Documenter, Arborist

makedocs(;
    modules=[Arborist],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/oxinabiox/Arborist.jl/blob/{commit}{path}#L{line}",
    sitename="Arborist.jl",
    authors="Lyndon White",
    assets=[],
)

deploydocs(;
    repo="github.com/oxinabiox/Arborist.jl",
)
