module lang::refinement::ConcreteSyntax

import lang::common::ConcreteSyntax;
import lang::crysl::ConcreteSyntax; 

start syntax RefinementDef = refineSpec: "SPEC" Id "REFINES" QualifiedType "{" RefinementElementDef+ "}" ; 

syntax RefinementElementDef = defineLiteralSet: "define" Id "=" LiteralSetDef ";" 
                            | defineQualifiedType: "define" Id "=" QualifiedType ";"
                            | addConstraint: "add" "constraint" ConstraintDef ";" 
                            | addEvent: "add" "event" EventDef; 

keyword RefinementKeyword = "SPEC" | "REFINES";