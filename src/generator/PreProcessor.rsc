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
	case constraintClause(cs) => updateConstraints(r, cs)
	case eventClause(es) => updateEvents(r, es)  
	case metaVariable(var) => bindVariable(r, var)
};

LiteralSet bindVariable(Refinement r, str var) {
  switch([s | defineVar(v,s) <- r.refinements, v == var]) {
     case [literalSet(x)] : return literalSet(x); 
     default  : throw  "invalid definition for variable " + var; 
  };
}

EventClause updateEvents(Refinement r, list[EventDecl] es) = eventClause(es + [e | addEvent(e) <- r.refinements]); 

ConstraintClause updateConstraints(Refinement r, list[Constraint] cs) = constraintClause(cs + [c | addConstraint(c) <- r.refinements]);
