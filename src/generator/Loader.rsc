module generator::Loader

import IO;
import ParseTree;

import Map; 

import lang::configuration::AbstractSyntax; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::Parser; 

import lang::refinement::AbstractSyntax; 
import lang::refinement::Parser; 

public map[str, Spec] specifications = (); 
public map[str, Refinement] refinements = (); 

public void load(Configuration config) {
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
		case loadRefinement(refinement): { 
			fullPath += src + "/" + specification + ".ref";
			location = |file:///| + fullPath; 
 			r = parseSpecification(location);
 			specifications += (r.name : r);
		}	
	};
}