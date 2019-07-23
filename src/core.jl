# Give all the arguments the names they have in the signature
function insert_function_preamble(body, def, call_args_typetuple)
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
    return body
end

# Can't graft intrinsics
graft(grafter, f::Core.IntrinsicFunction, args...) = f(args...)
# for prototyping purpose ban grafting on constructors
graft(grafter, f::Type, args...) = f(args...)

struct Reflection
    grafter
    meth::Method
    ast
    def::Dict{Symbol}
end

"""
As generated functions can't call things defined after them
we call this function to redefine `graft`.
Do this after you have defined your grafters and everything
they call.
"""
function redeclare_graft()
    @eval @inline @generated function graft(grafter, f, call_args...)
#        Core.println(string("*** ", f))
        Core.println(call_args)
        call_args_typetuple = Tuple{call_args...}
        meth = get_method(f, call_args_typetuple)
        Core.println(string("*** ", meth))

        ast = get_ast(meth)
        if ast===nothing
            return quote
                # for dev purposes
                #@warn "No AST got. Directly invoking."
                f(call_args...)
            end
        end

        def = MacroTools.splitdef(ast)
        body = def[:body]

        # Do the actual replacement (grafting)
        reflection = Reflection(grafter.instance, meth, body, def)
        body = grafter.instance(reflection)
        
        body = qualify_calls!(body, meth.module)
        body = insert_function_preamble(body, def, call_args_typetuple)
        body = MacroTools.flatten(body)
        
        #Core.println(sprint((io,x)->dump(io, x;maxdepth=100), body)); Core.println()
        Core.println(repr(body))
        Core.println()
        
        return body 
    end
end

redeclare_graft() #We are actually defining it the first time here