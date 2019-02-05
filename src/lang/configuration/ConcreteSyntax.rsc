module lang::configuration::ConcreteSyntax

import lang::common::ConcreteSyntax;

start syntax ConfigurationDef = configuration: "config" Id "{" "src" "=" Path ";" "out" "=" Path ";" LoadModuleDef+ "}" ;

syntax LoadModuleDef = loadSpec: "load" "spec" Path ";" 
                     | loadRefinement: "load" "refinement" Path ";" ; 

keyword Keywords = "CONFIG";