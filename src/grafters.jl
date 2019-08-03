"This is a demo grafter that has no effect"
function recurse_only_grafter(reflection)
    body = reflection.ast
    MacroTools.postwalk(body) do expr
        if isexpr(expr, :call)
            # TODO: make this ref `graft` right when in module
            # TODO: make this do kwargs right
            Expr(:block,
             #   :(println("Calling ", $(expr.args[1]))),
                recurse!(expr, reflection)
            )
        else
            expr
        end
    end
end
    
function translate_strings_grafter(reflection)
    ast = reflection.ast
    MacroTools.postwalk(ast) do expr
        if isexpr(expr, :call)
            return recurse!(expr, reflection)
        elseif isexpr(expr, String) ## String literal
            # Stub for actually translating the text
            return uppercase(expr)
        else
            return expr
        end
    end
end
            
@inline function fma_grafter(reflection)
    ast = reflection.ast
    MacroTools.prewalk(ast) do expr
        if (
            @capture(expr, x_ * y_ + z_) ||
            @capture(expr, z_ + x_ * y_)        
            )
            
            return :(fma($x, $y, $z)) 
        elseif isexpr(expr, :call)
            return Expr(:call,
                :graft, fma_grafter, expr.args...
            )
        end
        return expr
    end
end
