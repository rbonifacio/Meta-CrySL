module generator::PreProcessor

import IO;
import Map;

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax; 

import generator::PrettyPrinter; 

public void executePreProcessor(map[str, Spec] specifications, map[str, Refinement] refinements) {
	for(key <- refinements) {
	    r = refinements[key]; 
		top-down visit(specifications[r.baseSpec])	{
			case metaVariable(var) => bindVariable(r, var)  
		};
	};
	
	println("Starting the pretty printer"); 
	
	for(key <- specifications) {
		s = specifications[key]; 
		strSpec = prettyPrint(s);
		println(strSpec);
	}			
}

LiteralSet bindVariable(Refinement r, str var) {
 return  switch([s | defineVar(v,s) <- r.refinements, v == var]) {
     case [literalSet(x)] : return literalSet(x); 
     default  : throw  "invalid definition for variable " + var; 
  };
}
