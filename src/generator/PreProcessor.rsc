module generator::PreProcessor

import IO;
import Map;

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax; 

import generator::PrettyPrinter; 

public map[str, Spec] executePreProcessor(<map[str, Spec] specifications, map[str, Refinement] refinements>) 
  = (s.name: preProcess(r, s) | k <- refinements, r := refinements[k], s := specifications[r.baseSpec]); 
	

Spec preProcess(Refinement r, Spec s) = top-down visit(s) {
	case constraintClause(cs) => updateConstraints(r, cs)
	case eventClause(es) => updateEvents(r, es)  
	case metaObjectDecl(metaVar, arr, varName) => bindObjectDecl(r, metaVar, arr, varName) 
	case metaVariableSet(var) => bindLiteralSet(r, var)
};

ObjectDecl bindObjectDecl(Refinement r, MetaVariable var, bool arr, str varName) {
  switch([s | defineQualifiedType(v,s) <- r.refinements, metaVariable(v) == var]) {
     case [qt] : return objectDecl(qt, arr, varName); 
     default  : throw  "invalid definition for variable "; 
  };
}

LiteralSet bindLiteralSet(Refinement r, MetaVariable var) {
  switch([s | defineLiteralSet(v,s) <- r.refinements, metaVariable(v) == var]) {
     case [literalSet(x)] : return literalSet(x); 
     default  : throw  "invalid definition for variable "; 
  };
}

EventClause updateEvents(Refinement r, list[EventDecl] es) = eventClause(es + [e | addEvent(e) <- r.refinements]); 

ConstraintClause updateConstraints(Refinement r, list[Constraint] cs) = constraintClause(cs + [c | addConstraint(c) <- r.refinements]);
