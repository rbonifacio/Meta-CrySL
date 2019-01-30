module generator::PreProcessor

import IO;
import Map;

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax; 

public void executePreProcessor(map[str, Spec] specifications, map[str, Refinement] refinements) {
	for(key <- refinements) {
	    r = refinements[key]; 
		top-down visit(specifications[r.baseSpec])	{
			case metaVariable(var): println("found: " + var);  
		};
	};
		
}