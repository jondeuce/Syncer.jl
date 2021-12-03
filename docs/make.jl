pushfirst!(LOAD_PATH, @__DIR__)
pushfirst!(LOAD_PATH, joinpath(@__DIR__, ".."))
using Documenter, Syncer

makedocs(;
    modules = [Syncer],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
    ),
    sitename = "Syncer.jl",
    authors = "Jonathan Doucette",
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/jondeuce/Syncer.jl.git",
    push_preview = true,
    deploy_config = Documenter.GitHubActions(),
)
