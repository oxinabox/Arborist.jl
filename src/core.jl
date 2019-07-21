# Give all the arguments the names they have in the signature
function insert_function_preamble!(body, def, call_args_typetuple)
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
end

# Can't graft intrinsics
graft(f::Core.IntrinsicFunction, args...) = f(args...)
# Can't graft constructors (for now)

#function prepare_graft(grafter)
@generated function graft(grafter, f, call_args...)
    call_args_typetuple = Tuple{call_args...}
    meth = get_method(f, call_args_typetuple)
    Core.println(string("*** ",meth))
    
    ast = get_ast(meth)
    if ast===nothing
#        return Expr(:call, :f, :call_args)
        return quote
            # for dev purposes
            #@warn "No AST got. Directly invoking." #method=$meth
            f(call_args...)
        end
    end
    
    def = MacroTools.splitdef(ast)
    body = def[:body]
    body = qualify_calls!(body, meth.module)
    
    # Do the actual replacement (grapfting)
    body = Base.invokelatest(grafter.instance, body)
    insert_function_preamble!(body, def, call_args_typetuple)
    
    body = MacroTools.flatten(body)
    #Core.println(sprint((io,x)->dump(io, x;maxdepth=100), body)); Core.println()
    #Core.println(repr(body)) 
    return body 
end
