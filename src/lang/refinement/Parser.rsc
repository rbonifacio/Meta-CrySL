module lang::refinement::Parser

import IO; 
import ParseTree; 

import lang::common::AbstractSyntax; 
import lang::common::ConcreteSyntax; 

import lang::refinement::AbstractSyntax; 
import lang::refinement::ConcreteSyntax; 


public Refinement parseRefinement(loc file) {
	contents = readFile(file); 
	return implode(#Refinement, parse(#RefinementDef, contents)); 		
}