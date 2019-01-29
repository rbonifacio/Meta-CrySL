module generator::Loader

import IO;
import ParseTree;

import Map; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::Parser; 
import lang::refinement::AbstractSyntax; 
import lang::configuration::AbstractSyntax; 

public map[str, Spec] specifications; 
public map[str, Refinement] refinements; 

public void load(Configuration config) {
    specification = (); 
    refinements = ();
	for(LoadModule l <- config.modules) {
		parseModule(config.src, l); 
	};
}


public void parseModule(str src, LoadModule l) {
	fullPath = "";
	switch(l) {
		case loadSpec(specification) : { 
			fullPath += src + "/" + specification + ".cryptsl";
			location = |file:///| + fullPath; 
 			s = parseSpecification(location);
 			specifications += (s.name : s);
		}
		case loadRefinement(refinement): println(refinement);	
	};
}