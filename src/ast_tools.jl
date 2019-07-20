"extracts the type-param name from split_def(...)[:wherevars]"
wherevar(v::Symbol) = v
wherevar(expr::Expr) = expr.args[1]

function qualify_calls!(ast, mod)
    MacroTools.postwalk(ast) do expr
        if isexpr(expr, :call) || isexpr(expr, :macrocall)
            expr.args[1] = qualify_name(mod, expr.args[1])
        end
        expr
    end
end
qualify_name(mod::Module, name) = qualify_name(nameof(mod), name)
qualify_name(mod::Symbol, name::Symbol) = Expr(:., mod, QuoteNode(name))
qualify_name(mod, name) = name ## fallback, don't mess with things

"""
    is_allowable_generated_body(body_ast)

Generated functions are not allowed to do a bunch of things,
in the body they generate.z

"""
is_allowable_generated_body(::Any)=true
function is_allowable_generated_body(body::Expr)
    if (
        body.head ∈ (:comprehension, :generator, :global, :->) ||
        isdef(body)
    )
        return false
    end
    return all(is_allowable_generated_body, body.args)
end