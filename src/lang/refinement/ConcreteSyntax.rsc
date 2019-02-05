module lang::refinement::ConcreteSyntax

import lang::common::ConcreteSyntax;
import lang::crysl::ConcreteSyntax; 

start syntax RefinementDef = refineSpec: "SPEC" Id "REFINES" QualifiedType "{" RefinementElementDef+ "}" ; 

syntax RefinementElementDef = defineVar: "define" Id "=" LiteralSetDef ";" 
                            | addConstraint: "add" "constraint" ConstraintDef ";"; 

keyword RefinementKeyword = "SPEC" | "REFINES";