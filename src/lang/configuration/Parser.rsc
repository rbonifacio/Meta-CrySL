module lang::configuration::Parser

import IO; 
import ParseTree; 

import lang::common::AbstractSyntax; 
import lang::common::ConcreteSyntax; 

import lang::configuration::AbstractSyntax; 
import lang::configuration::ConcreteSyntax; 


public Configuration parseConfiguration(loc file) {
	contents = readFile(file); 
	return implode(#Configuration, parse(#ConfigurationDef, contents)); 	
}

start[Configuration] parseConfigurationLanguage(str p, loc l) = parse(#start[Configuration], p, l);