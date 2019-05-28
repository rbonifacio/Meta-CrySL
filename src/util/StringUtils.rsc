module util::StringUtils

import String; 

public str toSimpleName(str fullQualifiedName) {
	int idx = findLast(fullQualifiedName, ".");
	return substring(fullQualifiedName, idx+1);
}