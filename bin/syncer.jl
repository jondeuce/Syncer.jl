pushfirst!(LOAD_PATH, joinpath(@__DIR__, ".."))
using Syncer
Syncer.command_main()
