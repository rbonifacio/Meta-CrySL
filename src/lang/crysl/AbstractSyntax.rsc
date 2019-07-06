module lang::crysl::AbstractSyntax

import util::Maybe; 

import lang::common::AbstractSyntax; 

public data Spec = spec(bool abstract, 
                        str name, 
                        list[str] formalSpecParameters,
                        ObjectClause objectClause, 
                        list[ForbiddenClause] forbiddenClause, 
                        EventClause eventClause, 
                        EventOrder eventOrder, 
                        list[ConstraintClause] constraintClause, 
                        list[RequireClause] requireClause, 
                        list[EnsureClause] ensureClause,
                        list[NegateClause] negateClause);
                        

public data ObjectClause = objectClause(list[ObjectDecl] objectDecls); 
   
public data ObjectDecl = objectDecl(str qualifiedType, list[str] typeParameter, bool arr, str varName)
                       | metaObjectDecl(MetaVariable metaVar, bool arr, str varName)
                       | typeParameterObjectDecl(str pmt, bool arr, str varName)
                       ; 

public data ForbiddenClause = forbidden(list[ForbiddenMethod] methods); 

public data EventClause = eventClause(list[EventDecl] eventDecls); 

public data EventDecl = event(list[str] label, list[str] varName, Method method) 
                      | aggregate(str aggregateName, list[str] labels);

public data EventOrder = eventOrder(EventExp exp); 
                      
public data EventExp = optional(EventExp)
                     | sequence(EventExp, EventExp) 
                     | or(EventExp, EventExp)
                     | zeroOrMore(EventExp)
                     | oneOrMore(EventExp) 
                     | parentheses(EventExp)
                     | label(str event)
                     ; 
                     
public data ConstraintClause = constraintClause(list[Constraint] constraints); 

public data Constraint = inSetConstraint(SimpleExpression constraint, LiteralSet values) 
 					   | predicate(bool negation, str pred, list[SimpleExpression] objects, list[str] event)
 					   | noCallTo(str label) 
 					   | callTo(str label)
 					   | neverTypeOf(str var, str qualifiedType)
 					   | andConstraint(Constraint lhs, Constraint rhs) 
					   | orConstraint(Constraint lhs, Constraint rhs) 
                       | impliesConstraint(Constraint lhs, Constraint rhs)
                       | simpleExpression(SimpleExpression exp)
                       ;

                     
public data SimpleExpression = expNatural(int natValue)
                             | expVar(str varName)
                             | functionCall(str funtionName, list[Parameter] pmts)
                             | wildcardParameter()
                             | addConstraint(SimpleExpression, SimpleExpression)
 					         | subExpression(SimpleExpression, SimpleExpression)  
                             | ltConstraint(SimpleExpression, SimpleExpression)
                             | gtConstraint(SimpleExpression, SimpleExpression) 
                             | leqConstraint(SimpleExpression, SimpleExpression)
                             | geqConstraint(SimpleExpression, SimpleExpression) 
                             | eqConstraint(SimpleExpression, SimpleExpression)
                             | neqConstraint(SimpleExpression, SimpleExpression)
                             ;

public data Parameter = varParameter(str var)
                      | natParameter(int val)
                      | strParameter(str txt)
                      ;                               
                              
public data ForbiddenMethod = forbiddenMethod(str name, list[FormalArgument] args, list[str] context);

public data FormalArgument = formalArgument(str qualifiedType, bool arr); 
                              
public data Method = method(str name, list[Argument] formalArgs)
                   | typeParameterMethodDecl(str name, list[Argument] formalArgs);
                        
public data Argument = wildcard() 
                     | concreteParameter(str parameterName); 

public data RequireClause = requireClause(list[Constraint] constraints); 

public data EnsureClause = ensureClause(list[Constraint] constraints); 

public data NegateClause = negateClause(list[Constraint] constraints); 


Spec renameSpec(str n, Spec s) { s[name = n]; return s;}