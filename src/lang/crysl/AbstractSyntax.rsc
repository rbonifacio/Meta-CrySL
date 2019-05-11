module lang::crysl::AbstractSyntax

import util::Maybe; 

import lang::common::AbstractSyntax; 


public data Spec = spec(bool abstract, 
                        str name, 
                        list[str] formalSpecParameters,
                        ObjectClause objectClause, 
                        EventClause eventClause, 
                        EventOrder eventOrder, 
                        ConstraintClause constraintClause, 
                        list[RequireClause] requireClause, 
                        EnsureClause ensureClause);
                        

public data ObjectClause = objectClause(list[ObjectDecl] objectDecls); 
   
public data ObjectDecl = objectDecl(str qualifiedType, bool arr, str varName)
                       | metaObjectDecl(MetaVariable metaVar, bool arr, str varName)
                       | typeParameterObjectDecl(str pmt, bool arr, str varName)
                       ; 

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

public data Constraint = inSetConstraint(str varName, LiteralSet values) 
                       | impliesConstraint(Constraint lhs, Constraint rhs)
                       | ltConstraint(SimpleConstraint, SimpleConstraint)
                       | gtConstraint(SimpleConstraint, SimpleConstraint) 
                       | leqConstraint(SimpleConstraint, SimpleConstraint)
                       | geqConstraint(SimpleConstraint, SimpleConstraint) 
                       ;

                     
public data SimpleConstraint = expNatural(int natValue)
                             | expVar(str varName)
                             | objectProperty(str property, str object)
                             ;
                              
public data Method = method(str name, list[Argument] formalArgs)
                   | typeParameterMethodDecl(str name, list[Argument] formalArgs);
                        
public data Argument = wildcard() 
                     | concreteParameter(str parameterName); 

public data RequireClause = requireClause(list[Predicate] predicates); 

public data EnsureClause = ensureClause(list[Predicate] predicates); 

public data Predicate = predicate(str pred, list[Argument] objects, list[str] event); 


Spec renameSpec(str n, Spec s) { s[name = n]; return s;}