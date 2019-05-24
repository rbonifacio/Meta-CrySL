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
'<ppRequireClause(spec.requireClause)>
'<ppEnsureClause(spec.ensureClause)>
";

str ppObjectClause(list[ObjectDecl] os) = 
"OBJECTS 
' <for(obj <- os) {>  
'   <ppObject(obj)> 
' <}>
";

str ppObject(ObjectDecl obj)  {
	if(obj.arr) return "<obj.qualifiedType>[] <obj.varName>;"; 
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
'    foo ppConstraint(c); 
' <}>
";
 
str ppConstraint(Constraint c) { 
	switch(c) {
		case inSetConstraint(name, vs) : return "<name> in <ppLiteralSet(vs)>";
		case predicate(negation, pred, objects, event) : return ppPredicate(predicate(negation, pred, objects, event));
		case noCallTo(str label) : return "noCallTo(<label>)";
		case callTo(str label) : "callTo(<label>)";
		case andConstraint(Constraint lhs, Constraint rhs): return "<ppConstraint(lhs)> && <ppConstraint(rhs)>"; 
		case orConstraint(Constraint lhs, Constraint rhs): return "<ppConstraint(lhs)> || <ppConstraint(rhs)>";  
		case impliesConstraint(lhs, rhs) : return "<ppConstraint(lhs)> =\> <ppConstraint(rhs)>";
		case simpleExpression(exp) : return ppSimpleExpression(exp); 
		default: return "error"; 
	}	 
}

str ppSimpleExpression(SimpleExpression c) {
	switch(c) {
		case expNatural(n) : return "<n>";
		case expVar(v) : return "<v>"; 
		case functionCall(functionName, pmts) : return "<functionName>(<ppValues(pmts)>)";
		case wildcardParameter() : return "_"; 
		case addConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> + <ppSimpleExpression(rhs)>";  
 		case subExpression(lhs, rhs) : return "<ppSimpleExpression(lhs)> - <ppSimpleExpression(rhs)>"; 
		case ltConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> \< <ppSimpleExpression(rhs)>";
		case gtConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> \> <ppSimpleExpression(rhs)>";
		case leqConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> \<= <ppSimpleExpression(rhs)>";
		case geqConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> \>= <ppSimpleExpression(rhs)>";
		case eqConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> == <ppSimpleExpression(rhs)>"; 
        case eqConstraint(lhs, rhs) : return "<ppSimpleExpression(lhs)> != <ppSimpleExpression(rhs)>";
	}
}

str ppLiteralSet(LiteralSet s) {
	switch(s) {
		case literalSet(values) : return "{<ppValues([v | v <- values])>}"; 
		case metaVariable(str varName): return "${varName}";
	}
}

str ppParameter(list[Parameter] pmts) { 
  switch(pmts) {
    case [] : return  ""; 
    case [v] : return ppParameter(v); 
    case [v, *vs] : return  ppParameter(v) + "," + ppParameters(vs); 
  }
}

str ppParameter(varParameter(var)) = "<var>"; 
str ppParameter(natParameter(val)) = "<val>";
str ppParameter(strParameter(txt)) = "<txt>";

str ppValues(list[Literal] values) {
 switch(values) { 
   case []: return "";
   case [intLiteral(v)] : return "<v>";
   case [stringLiteral(v)] : return "<v>";
   case [intLiteral(v), *vs] : return "<v>, <ppValues(vs)>"; 
   case [stringLiteral(v), *vs]: return  "<v>, <ppValues(vs)>"; 
 };
}

str ppRequireClause([]) = ""; 
str ppRequireClause([req]) = 
"REQUIRES
' <for (p <- req.constraints){> 
'    <ppConstraint(p)>
' <}>
"; 

/**
 * We use a list of ensure clauses because it is 
 * optional. Either we get an empty list or we get 
 * a list with one element. 
 */
str ppEnsureClause([]) = "";  
str ppEnsureClause([ens]) = 
"ENSURES
' <for (p <- ens.constraints){>
'   <ppConstraint(p)>
' <}> 
"; 

str ppPredicate(predicate(false, n, objs, [])) = "<n>[<ppList(mapper(objs, ppSimpleExpression))>];";
str ppPredicate(predicate(false, n, objs, [e])) = "<n>[<ppList(mapper(objs, ppSimpleExpression))>] after <e>;";
str ppPredicate(predicate(true, n, objs, [])) = "!<n>[<ppList(mapper(objs, ppSimpleExpression))>];";
str ppPredicate(predicate(true, n, objs, [e])) = "!<n>[<ppList(mapper(objs, ppSimpleExpression))>] after <e>;";

  
str ppList(list[str] elements, str delimiter = ", ") = intercalate(delimiter, elements);