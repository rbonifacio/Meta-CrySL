module generator::Main

import IO;
import ParseTree; 

import lang::configuration::AbstractSyntax; 
import lang::configuration::ConcreteSyntax; 
import lang::configuration::Parser;

import generator::Loader; 

void main(loc configurationFile) {
	Configuration c = parseConfiguration(configurationFile); 
	executeLoader(c); 
}