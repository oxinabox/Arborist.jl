get_method(f, args::Tuple) = get_method(f, Tuple{args...})
function get_method(f::Type{F}, args::Type{<:Tuple}) where F<:Function
    return get_method(F.instance, args)
end
get_method(f, args::Type{<:Tuple}) = Base.which(f, args)


function get_ast(meth::Method)
    ast = definition(meth)
    return MacroTools.striplines(ast)
end

functiontypeof(m::Method) = parameter_typeof(m.sig)[1]
parameter_typeof(sig::UnionAll) = parameter_typeof(sig.body)
parameter_typeof(sig::DataType) = sig.parameters

function determine_type_params(
        meth::Method, argtypes::Type{<:Tuple},
    )
    ftype = functiontypeof(meth)
    
    instance_sig = Tuple{ftype, argtypes.parameters...}
    ti, lenv = ccall(
        :jl_type_intersection_with_env,
        Any, (Any, Any),
        instance_sig, meth.sig)
    return lenv
end
    