module lang::common::AbstractSyntax

public data Literal 
  = intLiteral(int intValue)
  | stringLiteral(str strValue)
  ;


public data LiteralSet = literalSet(set[Literal] values)
                       | metaVariable(str varName);
