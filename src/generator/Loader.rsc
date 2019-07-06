module generator::Loader

import IO;
import ParseTree;

import Map; 
import List;

import lang::common::AbstractSyntax; 

import lang::configuration::AbstractSyntax; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::Parser; 

import lang::refinement::AbstractSyntax; 
import lang::refinement::Parser; 

import generator::PreProcessor; 
import generator::IOUtil;

private map[str, Spec] specifications = (); 
private map[str, Refinement] refinements = (); 

public tuple[map[str, Spec], map[str, Refinement]] loadModules(Configuration config) {
   list[loc] files = []; 
   
   for(LoadModule l <- config.modules) {
      files += listFiles(config.src, l); 
   };
   
   for(loc file <- files) {
      parseModule(file);
   };
   return <specifications, refinements>;
}


public void parseModule(loc file) {
    print("Loading file: " + file.path); 
    
	if(file.extension == "cryptsl") {
		s = parseSpecification(file);
 		specifications += (s.name : s);
 		println("... ok"); 
	} else if(file.extension == "ref") {
		r = parseRefinement(file);
 			
 		//TODO: merge the refinements. not sure if this implementation is working.
 		// we definitly should implement some additional verifications here. 
 		// example: what happens when the two refinements have different 
 		// refinement parameters? 
 		if(r.name in refinements) {
 			old = refinements[r.name];
 			r = mergeR(old, r); 
 		}
	
		refinements += (r.name : r);
		println("... ok"); 
	}
}


/* -------------------- merge refinements --------------------------- */
// TODO: for some reason, the reducer function did not work. 
// 
 
public list[Refinement] mergeRefinements([]) = [];
public list[Refinement] mergeRefinements([r]) = [r];
public list[Refinement] mergeRefinements([r1, r2, *rs]) = mergeR(r1, r2) + mergeRefinements(rs);


public Refinement mergeR(Refinement l, Refinement r)  = refineSpec(l.name, l.baseSpec, l.actualSpecParameters, mergeRefinementElements(l.refinements, r.refinements));

private list[RefinementElement] mergeRefinementElements(list[RefinementElement] l, list[RefinementElement] r) {
	list[RefinementElement] res = [];
	for(RefinementElement e <- l) {
		switch(e) {
			case defineLiteralSet(name, literalSet(values)) : res += defineLiteralSet(name, literalSet(values + {v | defineLiteralSet(n, literalSet(vs)) <- r, name == n, v <- vs}));   
			default: res += e;
		}
	}
	for(RefinementElement e <- r) {
		switch(e) {
			case defineLiteralSet(name, values) : { 
				temp = [n | defineLiteralSet(n, vs) <- res, name == n]; 
				switch(temp) { 
				  case [] : res += defineLiteralSet(name, values); 
				}
			}  
			default: res += e;
		}
	}
	return res;
}


list[loc] listFiles(str src, LoadModule l) {
  str fullPath = ""; 
  str name = ""; 
  str ext = ""; 
  
  switch(l) {
    case loadSpec(specification) : { ext = "cryptsl"; name = specification; } 
    case loadRefinement(refinement): { ext = "ref"; name = refinement; }  
  }

  fullPath += src + "/" + name;
  location = |file:///| + fullPath; 
			
  if(exists(location) && isDirectory(location)) {
     return findAllFiles(location, ext); 
  }
  
  fullPath += "." + ext; 
  location = |file:///| + fullPath;
  return [location];
}
