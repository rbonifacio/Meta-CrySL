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
   export(c, executePreProcessor(loadModules(c)));
   println("done"); 
}

void export(Configuration c, map[str, Spec] specs) {
   for(k <- specs) {
      println(prettyPrint(specs[k]));
      //loc p = |file:///| + c.out + "/" + k + ".cryptsl";
      //println(p);
      //writeFile(p, prettyPrint(specs[k]));  
   }
}