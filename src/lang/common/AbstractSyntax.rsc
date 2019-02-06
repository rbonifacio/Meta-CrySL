module lang::common::AbstractSyntax

public data Literal 
  = intLiteral(int intValue)
  | stringLiteral(str strValue)
  ;

public data MetaVariable = metaVariable(str varName);

public data LiteralSet = literalSet(set[Literal] values)
                       | metaVariableSet(MetaVariable metaVar); 
