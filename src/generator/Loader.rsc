module generator::Loader

import IO;
import ParseTree;

import Map; 

import lang::configuration::AbstractSyntax; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::Parser; 

import lang::refinement::AbstractSyntax; 
import lang::refinement::Parser; 

import generator::PreProcessor; 

private map[str, Spec] specifications = (); 
private map[str, Refinement] refinements = (); 

public tuple[map[str, Spec], map[str, Refinement]] loadModules(Configuration config) {
    for(LoadModule l <- config.modules) {
		parseModule(config.src, l); 
	};
	
	return <specifications, refinements>; 
}


public void parseModule(str src, LoadModule l, bool verbose = true) {
	fullPath = "";
	switch(l) {
		case loadSpec(specification) : {
		    fullPath += src + "/" + specification + ".cryptsl";
		    
		    if(verbose) print("Loading file " + fullPath); 
					    
			location = |file:///| + fullPath; 
 			s = parseSpecification(location);
 			specifications += (s.name : s);
 			
 			if(verbose) println(" ok"); 
		}
		case loadRefinement(refinement): { 
			fullPath += src + "/" + refinement + ".ref";
			
			if(verbose) print("Loading file " + fullPath); 
						
			location = |file:///| + fullPath; 
 			r = parseRefinement(location);
 			refinements += (r.name : r);
 			
 			if(verbose) println(" ok"); 
		}	
	};
}