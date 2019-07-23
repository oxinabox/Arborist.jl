# Hack: https://github.com/timholy/CodeTracking.jl/issues/45
#==
function Revise.get_def(method::Method; modified_files=Revise.revision_queue)
    yield()   # magic bug fix for the OSX test failures. TODO: figure out why this works (prob. Julia bug)
    filename = Revise.fixpath(String(method.file))
    if startswith(filename, "REPL[")
        isdefined(Base, :active_repl) || return false
        fi = Revise.add_definitions_from_repl(filename)
        hassig = false
        for (mod, exs) in fi.modexsigs
            for sigs in values(exs)
                hassig |= !isempty(sigs)
            end
        end
        return hassig
    end
    id = Revise.get_tracked_id(method.module; modified_files=modified_files)
    id === nothing && return false
    pkgdata = Revise.pkgdatas[id]
    filename = relpath(filename, pkgdata)
    if Revise.hasfile(pkgdata, filename)
        def = Revise.get_def(method, pkgdata, filename)
        def !== nothing && return true
    end
    # Lookup can fail for macro-defined methods, see https://github.com/JuliaLang/julia/issues/31197
    # We need to find the right file.
    if method.module == Base || method.module == Core || method.module == Core.Compiler
        @warn "skipping $method to avoid parsing too much code"
        CodeTracking.method_info[method.sig] = missing
        return false
    end    
    parentfile, included_files = Revise.modulefiles(method.module)
    if parentfile !== nothing
        def = Revise.get_def(method, pkgdata, relpath(parentfile, pkgdata))
        def !== nothing && return true
        for modulefile in included_files
            def = Revise.get_def(method, pkgdata, relpath(modulefile, pkgdata))
            def !== nothing && return true
        end
    end
    # As a last resort, try every file in the package
    for file in Revise.srcfiles(pkgdata)
        def = Revise.get_def(method, pkgdata, file)
        def !== nothing && return true
    end
    @warn "$(method.sig) was not found"
    # So that we don't call it again, store missingness info in CodeTracking
    CodeTracking.method_info[method.sig] = missing
    return false
end
==#