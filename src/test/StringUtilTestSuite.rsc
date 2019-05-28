module \test::StringUtilTestSuite

import util::StringUtils;

test bool testSimpleName() {
	str s = "Cipher"; 
	str f = "javax.crypto.Cipher"; 
	
	return toSimpleName(s) == s && toSimpleName(f) == s; 
}