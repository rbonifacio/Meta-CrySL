module lang::crysl::AbstractSyntax


import lang::common::AbstractSyntax; 


public data Spec = spec(bool abstract, 
                        str name, 
                        ObjectClause objectClause, 
                        EventClause eventClause, 
                        EventOrder eventOrder, 
                        ConstraintClause constraintClause, 
                        RequireClause requireClause, 
                        EnsureClause ensureClause);
   
public data ObjectClause = objectClause(list[ObjectDecl] objectDecls); 
   
public data ObjectDecl = objectDecl(str qualifiedType, str varName); 

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
                       ;
                        
public data Method = method(str name, list[Argument] formalArgs);
                        
public data Argument = wildcard() 
                     | concreteParameter(str parameterName); 

public data RequireClause = requireClause(list[Predicate] predicates); 

public data EnsureClause = ensureClause(list[Predicate] predicates); 

public data Predicate = predicate(str pred, list[str] objects, list[str] event); 
