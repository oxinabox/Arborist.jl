# Arborist

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://oxinabiox.github.io/Arborist.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://oxinabiox.github.io/Arborist.jl/dev)
[![Build Status](https://travis-ci.com/oxinabiox/Arborist.jl.svg?branch=master)](https://travis-ci.com/oxinabiox/Arborist.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/oxinabiox/Arborist.jl?svg=true)](https://ci.appveyor.com/project/oxinabiox/Arborist-jl)
[![Codecov](https://codecov.io/gh/oxinabiox/Arborist.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/oxinabiox/Arborist.jl)
[![Coveralls](https://coveralls.io/repos/github/oxinabiox/Arborist.jl/badge.svg?branch=master)](https://coveralls.io/github/oxinabiox/Arborist.jl?branch=master)


Arborist is like Cassette Passes, or IRTools Dynamos,
but rather than working at the level of transforming untyped IR to different untyped IR,
it works at the level of AST expressions.

It is a very early prototype, look in the source to see some exprimentations in this direction.

The short answer to how it works is that it uses CodeTracking to retrieve the AST of any method,
then uses a generated function to run what ever modified AST you have declared.
