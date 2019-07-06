module generator::PreProcessor

import IO;
import List; 
import Map;
import String; 

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::refinement::AbstractSyntax; 

import generator::PrettyPrinter; 

public map[str, Spec] executePreProcessor(<map[str, Spec] specifications, map[str, Refinement] refinements>) {
	// run the actual preprocessors. 
	refinedSpecs = (s.name: preProcess(r, s) | k <- refinements, r := refinements[k], s := specifications[r.baseSpec]); 
	
	nonRefinedSpecs = (k : s | k <- specifications, !(k in refinedSpecs), s := specifications[k]); 
	
	// as a final step, rename the specifications. 
	return nonRefinedSpecs + (s.name : s | k <- refinements, r := refinements[k], s:= rename(r, refinedSpecs[r.baseSpec])); 
}

/* renames a specification using a rename refinement */ 

private Spec rename(Refinement r, Spec s) {
	names = [n | rename(n) <- r.refinements]; 
	switch(names) {
		case [x] : { Spec renamed =  s[name = x]; return renamed; }
		default  : return s;  
	};
}
	
private Spec preProcess(Refinement r, Spec s) = top-down visit(s) {
	case constraintClause(cs) => updateConstraints(r, cs)
	case requireClause(cs) => updateRequires(r, cs)
	case eventClause(es) => updateEvents(r, es)  
	case metaObjectDecl(metaVar, arr, varName) => bindObjectDecl(r, metaVar, arr, varName) 
	case typeParameterObjectDecl(pmt, arr, varName) => bindTypeParameter(r, s, pmt, arr, varName)
	case typeParameterMethodDecl(name, args) => bindTypeParameterMethod(r, s, name, args) 
	case metaVariableSet(var) => bindLiteralSet(r, var)
};

private ObjectDecl bindObjectDecl(Refinement r, MetaVariable var, bool arr, str varName) {
  switch([s | defineQualifiedType(v,s) <- r.refinements, metaVariable(v) == var]) {
     case [qt] : return objectDecl(qt, [], arr, varName); 
     default  : throw  "invalid definition for variable "; 
  };
}

/* bind a spec parameter of an object declaration */ 

private ObjectDecl bindTypeParameter(Refinement r, Spec s, str pmt, bool arr, str varName) {
	map[str, str] env = (f:a | <f, a> <- zip(s.formalSpecParameters, r.actualSpecParameters)); 
	
	if(pmt in env) {
		return objectDecl(env[pmt], [], arr, varName); 
	}
	/* 
	 * If there is no binding for the type parameter, 
	 * we keep the specification with the spec parameter in 
	 * the object declaration. In this way, we could implement 
	 * a "staged configuration". 
	 */ 
	return typeParameterObjectDecl(pmt, arr, varName);
}

/* bind a typed parameter of a method */ 

private Method bindTypeParameterMethod(Refinement r, Spec s, str name, list[Argument] args)  {
	map[str, str] env = (f:a | <f, a> <- zip(s.formalSpecParameters, r.actualSpecParameters)); 
	
	if(name in env) {
		return method(baseType(env[name]), args); 
	}
	
	return typeParameterMethodDecl(name, args); 
}

private LiteralSet bindLiteralSet(Refinement r, MetaVariable var) {
  switch([s | defineLiteralSet(v,s) <- r.refinements, metaVariable(v) == var]) {
     case [literalSet(x)] : return literalSet(x); 
     default  : throw  "invalid definition for variable "; 
  };
}

private EventClause updateEvents(Refinement r, list[EventDecl] es) = eventClause(es + [e | addEvent(e) <- r.refinements]); 

private ConstraintClause updateConstraints(Refinement r, list[Constraint] cs) = constraintClause(cs + [c | addConstraint(c) <- r.refinements]);

private RequireClause updateRequires(Refinement r, list[Constraint] cs) = requireClause(cs + [c | addRequire(c) <- r.refinements]);

private str baseType(str fullQualifiedName) {
	int idx = findLast(fullQualifiedName, ".");
	
	if(idx == -1) {
		return fullQualifiedName; 
	}
	return substring(fullQualifiedName, idx + 1, size(fullQualifiedName));
}
