module generator::PrettyPrinter

import List; 

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax; 

str prettyPrint(Spec spec) = 
"SPEC <spec.name>
'  
'<ppObjectClause(spec.objectClause.objectDecls)>
'<ppEventClause(spec.eventClause.eventDecls)>
'<ppEventOrder(spec.eventOrder)>
'<ppConstraintClause(spec.constraintClause.constraints)>
";

str ppObjectClause(list[ObjectDecl] os) = 
"OBJECTS 
' <for(obj <- os) {>  
'   <ppObject(obj)> 
' <}>
";

str ppObject(ObjectDecl obj)  {
	if(obj.arr) return "<obj.qualifiedType>[] <obj.varName>"; 
	return "<obj.qualifiedType> <obj.varName>;"; 
}

str ppEventClause(list[EventDecl] es) = 
"EVENTS 
' <for(evt <- es) {>  
'    <ppEvent(evt)> 
' <}>
";

str ppEvent(EventDecl evt) {
	switch(evt) {
		case event(l, n, methodDef): return "<ppMethodEvent(l, n, methodDef)>;" ; 
		case aggregate(n, lbls) : return "<n> := <ppList(lbls, delimiter = " | ")>;"; 
	};
}

str ppEventOrder(eventOrder(EventExp exp)) = 
"ORDER
'  <ppEventExp(exp)>
";

str ppMethodEvent(list[str] eventLabel, list[str] varName, Method methodDef) {
	str res = ppMethod(methodDef);
	
	switch(varName) {
		case [n] : res = n + " = " + res; 
	} 
	
	switch(eventLabel) {
		case [l] : res = l + ": " + res; 
	}
	return res;
} 

str ppMethod(method(n, args)) {
	return "<n>(<ppList([ppArgument(arg) | arg <- args])>)"; 
}

str ppArgument(Argument arg) {
	switch(arg) {
		case wildcard() : return "_" ; 
		case concreteParameter(n) : return n; 
	}
}

str ppEventExp(EventExp e) {
  switch(e) {
    case optional(e1)       : return "<ppEventExp(e1)>?"; 
    case sequence(lhs, rhs) : return "<ppEventExp(lhs)>, <ppEventExp(rhs)>";  
    case or(lhs, rhs)       : return "<ppEventExp(lhs)> | <ppEventExp(rhs)>";  
    case zeroOrMore(e1)     : return "<ppEventExp(e1)>*";
    case oneOrMore(e1)      : return "<ppEventExp(e1)>+";
    case parentheses(e1)    : return "(<ppEventExp(e1)>)";
    case label(evt)         : return evt; 
  }
}

str ppConstraintClause(list[Constraint] cs) = 
"CONSTRAINTS
' <for(c <- cs) {>  
'    <ppConstraint(c)> 
' <}>
";
 
str ppConstraint(Constraint c) { 
	switch(c) {
		case inSetConstraint(name, vs) : return "<name> in <ppLiteralSet(vs)>;";
		case impliesConstraint(lhs, rhs) : return "<ppConstraint(lhs)> =\> <ppConstraint(rhs)>;";
		
		default: return "error"; 
	}	 
}

str ppLiteralSet(LiteralSet s) {
	switch(s) {
		case literalSet(values) : return "{ <ppValues([v | v <- values])> }"; 
		case metaVariable(str varName): return "${varName}";
	}
}

str ppValues(list[Literal] values) {
 switch(values) { 
   case []: return "";
   case [intLiteral(v)] : return "<v>";
   case [stringLiteral(v)] : return "<v>";
   case [intLiteral(v), *vs] : return "<v>, <ppValues(vs)>"; 
   case [stringLiteral(v), *vs]: return  "<v>, <ppValues(vs)>"; 
 };
}

str ppList(list[str] elements, str delimiter = ", ") = intercalate(delimiter, elements);