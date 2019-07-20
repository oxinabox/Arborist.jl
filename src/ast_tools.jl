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