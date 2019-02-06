module lang::refinement::AbstractSyntax

import lang::common::AbstractSyntax; 
import lang::crysl::AbstractSyntax;

public data Refinement = refineSpec(str name, str baseSpec, list[RefinementElement] refinements); 

public data RefinementElement = defineLiteralSet(str varName, LiteralSet values)
                              | defineQualifiedType(str varName, str qualifiedType)
                              | addConstraint(Constraint ctr)
                              | addEvent(EventDecl evt);