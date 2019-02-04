module generator::PreProcessor

import IO;
import Map;

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax; 

import generator::PrettyPrinter; 

public list[Spec] executePreProcessor(map[str, Spec] specifications, map[str, Refinement] refinements) 
  = [preProcess(r, s) | k <- refinements, r := refinements[k], s := specifications[r.baseSpec]]; 
	

Spec preProcess(Refinement r, Spec s) = top-down visit(s)	{
	case metaVariable(var) => bindVariable(r, var)  
};

LiteralSet bindVariable(Refinement r, str var) {
  switch([s | defineVar(v,s) <- r.refinements, v == var]) {
     case [literalSet(x)] : return literalSet(x); 
     default  : throw  "invalid definition for variable " + var; 
  };
}
