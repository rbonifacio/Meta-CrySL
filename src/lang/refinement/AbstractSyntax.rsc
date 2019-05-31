module lang::refinement::AbstractSyntax

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax;

public data Refinement 
  = refineSpec(str name, str baseSpec, list[str] actualSpecParameters, list[RefinementElement] refinements); 

public data RefinementElement 
  = rename(str specName)
  | defineLiteralSet(str varName, LiteralSet values)
  | defineQualifiedType(str varName, str qualifiedType)
  | addConstraint(Constraint ctr)
  | addRequire(Constraint ctr)
  | addEvent(EventDecl evt);