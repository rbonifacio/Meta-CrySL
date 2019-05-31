module lang::refinement::ConcreteSyntax

import lang::common::ConcreteSyntax;
import lang::crysl::ConcreteSyntax; 

start syntax RefinementDef = refineSpec: "SPEC" Id "REFINES" QualifiedType ("\<" {QualifiedType ","}+ "\>")? "{" RefinementElementDef+ "}" ; 

syntax RefinementElementDef 
   = rename: "rename" "spec" QualifiedType ";"  
   | defineLiteralSet: "define" Id "=" LiteralSetDef ";" 
   | defineQualifiedType: "define" Id "=" QualifiedType ";"
   | addConstraint: "add" "constraint" ConstraintDef ";" 
   | addRequire: "add" "require" ConstraintDef ";" 
   | addEvent: "add" "event" EventDef; 

keyword RefinementKeyword = "SPEC" | "REFINES";