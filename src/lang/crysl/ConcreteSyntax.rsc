/**
 * Grammar specification for Meta-CrySL. 
 * @author: Rodrigo Bonifacio
 */
module lang::crysl::ConcreteSyntax

/* some lexical definitions */ 
lexical Natural 
  = [0-9]+ ;              

lexical String 
  = "\"" ![\"]*  "\"" ;

lexical Id 
  = ([a-zA-Z0-9] !<< [a-zA-Z] [a-zA-Z0-9]* !>> [a-zA-Z0-9]) \ Keyword
  ;
    
lexical QualifiedType 
  = {Id "."}+ ; 

/* The start symbol SpecDef */ 
start syntax SpecDef 
  = spec: "abstract"? "SPEC" Id  ObjectClauseDef EventClauseDef EventOrderDef ConstraintClauseDef RequireClauseDef EnsureClauseDef ;

/* Definitions for the object declaration section */ 

syntax ObjectClauseDef 
  = objectClause: "OBJECTS" ObjectDef+; 
  
syntax ObjectDef 
  = objectDecl: QualifiedType Id ";" ; 

/* Definitions for the event declaration section */ 
  
syntax EventClauseDef 
 = eventClause: "EVENTS" EventDef+ ;   
    
syntax EventDef 
  = event: (Id ":")? (Id "=")? MethodDef ";"  
  | aggregate: Id ":=" {Id "|"}+ ";" 
  ;  
  
syntax MethodDef 
  = method: Id "(" {ArgumentDef ","}* ")" ;  
  
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
  = inSetConstraint: Id "in" LiteralSetDef 
  | left impliesConstraint: ConstraintDef "=\>" ConstraintDef 
  ; 
  
/* Definitions for the require declaration section */ 

syntax RequireClauseDef
  = requireClause: "REQUIRES" PredicateDef+; 
  
  
/* Definitions for the ensure declaration section */ 
        
syntax EnsureClauseDef
  = ensureClause: "ENSURES" PredicateDef+; 

syntax PredicateDef 
  = predicate: Id "[" {Id ","}+"]" ("after" Id)?  ";" ; 

syntax LiteralDef 
  = intLiteral: Natural | stringLiteral: String ; 

syntax LiteralSetDef = literalSet: "{" {LiteralDef ","}+ "}" ; 

keyword Keyword 
  = "SPEC" | "OBJECTS" | "EVENTS" | "ORDER" 
  | "CONSTRAINTS" | "ENSURES" | "after" 
  | "CONFIG"  ;

lexical Comment =
  "/**/" 
  | "//" EOLCommentChars !>> ![\n \a0D] LineTerminator 
  | "/*" !>> [*] CommentPart* "*/" 
  | "/**" !>> [/] CommentPart* "*/" 
  ;
  
lexical LAYOUT =
  [\t-\n\ ] 
  | Comment 
  ;  
  
layout LAYOUTLIST  =
  LAYOUT* !>> [\t-\n \a0C-\a0D \ ] !>> (  [/]  [*]  ) !>> (  [/]  [/]  ) !>> "/*" !>> "//"
  ;

lexical BlockCommentChars =
  ![* \\]+ 
  ;  
