module lang::crysl::\test::ParserTestSuite

import IO; 
import ParseTree; 

import lang::crysl::AbstractSyntax; 
import lang::crysl::ConcreteSyntax; 

str objects     = "OBJECTS \n br.foo f; br.foo g;"; 
str events      = "EVENTS g1: abc(); g2: abcde(); g := g1 | g2;";
str order       = "ORDER g1 | g2"; 
str constraints = "CONSTRAINTS x in {1,2,3}; y in {4,5,6}; x in {4,5} =\> z in {10};";
str requires    = "REQUIRES pred[b] after a;";
str ensures     = "ENSURES pred[a] after b;";

test bool parseSpecClause() {
	str spec = "abstract SPEC foo" + "\n " + objects + "\n " + events + "\n " + order + "\n " + constraints + "\n " + requires + "\n " + ensures ; 
		
	parseTree = parse(#SpecDef, spec); 
	absTree = implode(#Spec, parseTree);  
	
	assert absTree.abstract; 
	assert absTree.name == "foo"; 
	assert size(absTree.objectClause.objectDecls) == 2;
	assert size(absTree.eventClause.eventDecls) == 3; 
	assert absTree.eventOrder.exp == or(label("g1"), label("g2")); 
	assert size(absTree.constraintClause.constraints) == 3;
	assert size(absTree.requireClause.predicates) == 1;
	assert size(absTree.ensureClause.predicates) == 1;
	
	return true; 
}

test bool parseObjectClause() {
	try {
	  parse(#ObjectClauseDef, objects); 
	  return true; 
	}
	catch : {
	  return false;
	}
}

test bool parseEventClauseDef() {
	try {
		parse(#EventClauseDef, events);
		return true;
	}
	catch : { 
		return false; 
	}

}

test bool parseEverntOrderDef() {
	try {
		parse(#EventOrderDef, order); 
		return true;	
   	}
   	catch : {
   		return false; 
   }
}

test bool parseConstraintClauseDef() {
	try {
		parse(#ConstraintClauseDef, constraints);
		return true; 
	}
	catch : {
		return false; 
	}
}

test bool parseEnsureClauseDef() {
		try {
		parse(#EnsureClauseDef, ensures);
		return true; 
	}
	catch : {
		return false; 
	}
}