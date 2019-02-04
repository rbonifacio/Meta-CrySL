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
	list[Spec] specs = executePreProcessor(ss, rs);
	
	for(s <- specs) {
		println(prettyPrint(s)); 
	}
}