module lang::refinement::AbstractSyntax

import lang::common::AbstractSyntax; 

public data Refinement = refineSpec(str name, str baseSpec, list[RefinementElement] refinements); 

public data RefinementElement = defineVar(str varName, LiteralSet values);