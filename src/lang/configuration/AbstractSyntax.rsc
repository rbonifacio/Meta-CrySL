module lang::configuration::AbstractSyntax

import lang::common::AbstractSyntax;


public data Configuration = configuration(str name, str src, str out, list[LoadModule] modules);

public data LoadModule = loadSpec(str specification)
                       | loadRefinement(str refinement) 
                       ; 