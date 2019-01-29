module lang::crysl::Parser

import IO; 
import ParseTree; 

import lang::common::AbstractSyntax; 
import lang::common::ConcreteSyntax; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::ConcreteSyntax; 


public Spec parseSpecification(loc file) {
	contents = readFile(file); 
	return implode(#Spec, parse(#SpecDef, contents)); 		
}