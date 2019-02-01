module generator::PrettyPrinter

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 

str prettyPrint(Spec spec) = 
"SPEC <spec.name>
'  
'OBJECTS 
'
'CONSTRAINTS
' <for(c <- spec.constraintClause.constraints) {>  
'    <ppConstraint(c)> 
' <}>
";


str ppConstraint(Constraint c) { 
	switch(c) {
		case inSetConstraint(name, vs) : return "<name> in <ppLiteralSet(vs)>";
		case impliesConstraint(lhs, rhs) : return "<ppConstraint(lhs)> =\> <ppConstraint(rhs)>";
		default: return "error"; 
	}	 
}

str ppLiteralSet(LiteralSet s) {
	switch(s) {
		case literalSet(values) : return ppValues(values); 
		default: return "bar";
	}
}

str ppValues(set[Literal] values) {
 switch(values) { 
   case {}: return "";
   case {intLiteral(v), *vs} : return "<v>, <ppValues(vs)>"; 
   case {stringLiteral(v), *vs}: return  "<v>, <ppValues(vs)>"; 
 };
}