module generator::Main

import IO;
import ParseTree; 

import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax;


import lang::configuration::AbstractSyntax; 
import lang::configuration::ConcreteSyntax; 
import lang::configuration::Parser;

import generator::Loader; 
import generator::PreProcessor; 
import generator::PrettyPrinter; 

void main(loc configurationFile) {
	Configuration c = parseConfiguration(configurationFile); 
	<ss, rs> = loadModules(c); 
	map[str, Spec] specs = executePreProcessor(ss, rs);
	
	for(k <- specs) {
		str outFile = c.out + "/" + k + ".cryptsl" ; 
		loc location = |file:///| + outFile; 
		writeFile(location, prettyPrint(specs[k]));
	}
	println("done"); 
}