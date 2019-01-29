module lang::configuration::ConcreteSyntax

import lang::common::ConcreteSyntax;

start syntax ConfigurationDef = configuration: "config" Id "{" "src" "=" String ";" "out" "=" String ";" LoadModuleDef+ "}" ;

syntax LoadModuleDef = loadSpec: "load" "spec" String ";" 
                     | loadRefinement: "load" "refinement" String ";" ; 

keyword Keywords = "CONFIG";