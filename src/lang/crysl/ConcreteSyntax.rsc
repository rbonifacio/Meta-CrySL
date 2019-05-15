/**
 * Grammar specification for Meta-CrySL. 
 * @author: Rodrigo Bonifacio
 */
module lang::crysl::ConcreteSyntax

import lang::common::ConcreteSyntax;


/* The start symbol SpecDef */ 
start syntax SpecDef 
  = spec: "abstract"? "SPEC" QualifiedType  ("\<" {Id ","}+ "\>")? ObjectClauseDef EventClauseDef EventOrderDef ConstraintClauseDef RequireClauseDef? EnsureClauseDef? ;


/* Definitions for the object declaration section */ 

syntax ObjectClauseDef 
  = objectClause: "OBJECTS" ObjectDef+; 
  
syntax ObjectDef 
  = objectDecl: QualifiedType ("[" "]")? Id ";"  
  | metaObjectDecl: MetaVariable ("[" "]")? Id ";" 
  | typeParameterObjectDecl: "\<" Id "\>" ("[" "]")? Id ";"
  ;

/* Definitions for the event declaration section */ 
  
syntax EventClauseDef 
 = eventClause: "EVENTS" EventDef+ ;   
    
syntax EventDef 
  = event: (Id ":")? (Id "=")? MethodDef ";"  
  | aggregate: Id ":=" {Id "|"}+ ";" 
  ;  
  
syntax MethodDef 
  = method: Id "(" {ArgumentDef ","}* ")" 
  | typeParameterMethodDecl: "\<" Id "\>""(" {ArgumentDef ","}* ")"
  ;  
  
syntax ArgumentDef 
  = wildcard: "_"
  > concreteParameter: Id 
  ;   

/* Definitions for the event order section */ 

syntax EventOrderDef 
  = eventOrder: "ORDER"  EventExpDef ;

syntax EventExpDef 
  = label: Id
  > optional: EventExpDef "?" 
  | zeroOrMore: EventExpDef "*"
  | oneOrMore: EventExpDef "+"  
  > left sequence: EventExpDef "," EventExpDef  
  > left or: EventExpDef "|" EventExpDef 
  | parentheses: "(" EventExpDef ")"
  ; 

/* Definitions for the constraint declaration section */ 

syntax ConstraintClauseDef 
  = constraintClause: "CONSTRAINTS" {ConstraintDef ";"}+ ";" ; 

syntax ConstraintDef 
  = inSetConstraint: SimpleExpressionDef "in" LiteralSetDef
  | predicate: "!"? Id "[" {SimpleExpressionDef ","}+"]" ("after" Id)?
  | noCallTo: "noCallTo" "(" Id ")"
  | callTo: "callTo" "(" Id ")"
  | simpleExpression: SimpleExpressionDef
  | left andConstraint: ConstraintDef "&&" ConstraintDef
  | left orConstraint: ConstraintDef "||" ConstraintDef 
  > left impliesConstraint: ConstraintDef "=\>" ConstraintDef
  ; 
  
syntax UtilityFunction = partFunction : "part" "(" Natural "," String "," Id ")" ;
                     
syntax SimpleExpressionDef = wildcardParameter: "_"
                           > expNatural : Natural
                           | expVar : Id
                           | functionCall: Id "(" {ParameterDef ","}* ")"
                           > left addConstraint: SimpleExpressionDef "+" SimpleExpressionDef
                           | left subConstraint: SimpleExpressionDef "-" SimpleExpressionDef 
                           > left ltConstraint: SimpleExpressionDef "\<" SimpleExpressionDef
                           | left gtConstraint: SimpleExpressionDef "\>" SimpleExpressionDef
                           | left leqConstraint: SimpleExpressionDef "\<=" SimpleExpressionDef
                           | left geqConstraint: SimpleExpressionDef "\>=" SimpleExpressionDef
                           | left eqConstraint: SimpleExpressionDef "==" SimpleExpressionDef
                           | left neqConstraint: SimpleExpressionDef "!=" SimpleExpressionDef
                           ;   
                           
syntax ParameterDef =  varParameter : Id
                    | natParameter : Natural
                    | strParameter : String 
                    ;
                      
/* Definitions for the require declaration section */ 

syntax RequireClauseDef
  = requireClause: "REQUIRES" {ConstraintDef ";"}+ ";" ; 
  
  
/* Definitions for the ensure declaration section */ 
        
syntax EnsureClauseDef
  = ensureClause: "ENSURES" {ConstraintDef ";"}+ ";" ; 


keyword Keyword 
  = "SPEC" | "OBJECTS" | "EVENTS" | "ORDER" 
  | "CONSTRAINTS" | "ENSURES" | "after" 
  | "CONFIG" | "noCallTo" | "callTo" ;

