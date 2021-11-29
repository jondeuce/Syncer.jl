module Syncer

using Comonicon

"""
Simple `rsync` wrapper.

# Arguments

- `source`: source folder
- `dest`: destination folder

# Flags

- `--common`: only sync common folders
- `--notdry`: perform syncing
"""
@main function main(
        source::String,
        dest::String;
        common::Bool = false,
        notdry::Bool = false,
    )
    @assert !endswith(source, "/")
    @assert !endswith(dest, "/")

    cmd = `rsync --recursive --compress --archive --delete --verbose --progress --stats`

    dry = !notdry
    if dry
        cmd = `$cmd --dry-run`
    end

    if common
        # Source folders to sync over
        sourcefolders = basename.(filter(isdir, readdir(source; join = true)))
        destfolders = basename.(filter(isdir, readdir(dest; join = true)))
        commonfolders = intersect(sourcefolders, destfolders)

        println("Only in source:")
        for fld in setdiff(sourcefolders, commonfolders)
            println(joinpath(source, fld))
        end

        println("Only in dest:")
        for fld in setdiff(destfolders, commonfolders)
            println(joinpath(dest, fld))
        end

        srclist = tempname()
        open(srclist; write = true) do io
            foreach(commonfolders) do fld
                println(io, fld)
            end
        end
        cmd = `$cmd --files-from=$srclist`
    end

    cmd = `$cmd $source/ $dest/`

    if dry
        run(pipeline(cmd, `less`))
    else
        run(cmd)
    end

    return nothing
end

end # module
