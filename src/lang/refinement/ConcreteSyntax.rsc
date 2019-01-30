module lang::refinement::ConcreteSyntax

import lang::common::ConcreteSyntax;

start syntax RefinementDef = refineSpec: "SPEC" Id "REFINES" QualifiedType "{" RefinementElementDef+ "}" ; 

syntax RefinementElementDef = defineVar: "define" Id "=" LiteralSetDef ";" ; 

keyword Keyword = "SPEC" | "REFINES";  
