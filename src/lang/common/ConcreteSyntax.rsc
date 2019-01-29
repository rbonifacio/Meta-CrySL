module lang::common::ConcreteSyntax

/* some lexical definitions */ 
lexical Natural 
  = [0-9]+ ;              

lexical String 
  = "\"" ![\"]*  "\"" ;

lexical Id 
  = ([a-zA-Z0-9] !<< [a-zA-Z] [a-zA-Z0-9_]* !>> [a-zA-Z0-9_]) \ Keyword
  ;
    
lexical QualifiedType 
  = {Id "."}+ ; 

lexical Path 
  = [a-zA-Z0-9/\-]*;
  
syntax LiteralDef 
  = intLiteral: Natural | stringLiteral: String ; 

syntax LiteralSetDef = literalSet: "{" {LiteralDef ","}+ "}" 
                     | metaVariable: "${" Id "}"
                     ; 

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
