@generated function graft(f, call_args...)
    call_args_typetuple = Tuple{call_args...}
    meth = get_method(f, call_args_typetuple)
    Core.println(string("****",meth))
    
    ast = get_ast(meth)
    ast===nothing && error("no AST got")
    
    def = MacroTools.splitdef(ast)
    body = def[:body]
    body = qualify_calls!(body, meth.module)
    
    
    # Do the actual replacement (grapfting)
    body = MacroTools.postwalk(body) do expr
        if isexpr(expr, :call)
            # TODO: make this ref `graft` right when in module
            # TODO: make this do kwargs right
            Expr(:block,
             #   :(println("Calling ", $(expr.args[1]))),
                Expr(:call, :graft, expr.args...)
            )
        else
            expr
        end
    end

    # Give all the arguments the names they have in the signature
    body = Expr(:block, body)
    if !isempty(def[:args])  # give args their local names
        argnames = first.(MacroTools.splitarg.(def[:args]))
        pushfirst!(body.args,
            Expr(:(=), 
                Expr(:tuple, argnames...),
                :call_args
            )
        )
    end
        
    if !isempty(def[:whereparams])  # give typeparams local names
        type_params = determine_type_params(meth, call_args_typetuple)
        pushfirst!(body.args,
            Expr(:(=),
                Expr(:tuple, wherevar.(def[:whereparams])...),
                :type_params
            )
        )
    end
    
    body = MacroTools.flatten(body)
    #Core.println(sprint((io,x)->dump(io, x;maxdepth=100), body)); Core.println()
    #Core.println(repr(body)) 
    return body 
end