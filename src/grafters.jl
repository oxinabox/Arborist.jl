function translate_strings_grafter(ast)
    MacroTools.postwalk(ast) do expr
        if isexpr(expr, :call)
            Expr(:block,
                Expr(:call,
                    :graft, translate_strings_grafter,
                    expr.args...
                )
            )
        elseif isexpr(expr, String) ## String literal
            # Stub for actually translating the text
            uppercase(expr)
        else
            expr
        end
    end
end

"This is a demo grafter that has no effect"
function recurse_only_grafter(expr)
    MacroTools.postwalk(body) do expr
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
end