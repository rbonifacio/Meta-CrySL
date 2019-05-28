module \test::MergeRefinementsTestSuite

import generator::Loader;
import lang::common::ConcreteSyntax; 
import lang::common::AbstractSyntax; 

import lang::crysl::ConcreteSyntax; 
import lang::crysl::AbstractSyntax; 
import lang::crysl::Parser; 

import lang::refinement::ConcreteSyntax; 
import lang::refinement::AbstractSyntax; 
import lang::refinement::Parser; 


import ParseTree;


str r1 = 
    "SPEC Cipher REFINES javax.crypto.Cipher {
	'  define algorithm = {\"AES\", \"DESede\", \"RSA\"};
	'  define aes_modes = {\"CBC\", \"CFB\", \"CTR\", \"CTS\", \"ECB\", \"OFB\"};
	'  add constraint part(0, \"/\", transformation) in {\"AES\"} =\> part(1, \"/\", transformation) in ${aes_modes};
	'}" ;
	

str r2 = 
    "SPEC Cipher REFINES javax.crypto.Cipher {
	'  define algorithm = {\"BLOWFISH\"};
	'  add constraint part(0, \"/\", transformation) in {\"BLOWFISH\"} =\> part(1, \"/\", transformation) in {\"CBC\"};
	'  add constraint part(0, \"/\", transformation) in {\"BLOWFISH\"} =\> part(2, \"/\", transformation) in {\"NoPadding\"};
	'}" ;
	

str r3 = 
    "SPEC Cipher REFINES javax.crypto.Cipher {
	'  define algorithm = {\"AES\", \"DESede\", \"RSA\", \"BLOWFISH\"};
	'  define aes_modes = {\"CBC\", \"CFB\", \"CTR\", \"CTS\", \"ECB\", \"OFB\"};
	'  add constraint part(0, \"/\", transformation) in {\"AES\"} =\> part(1, \"/\", transformation) in ${aes_modes};
	'  add constraint part(0, \"/\", transformation) in {\"BLOWFISH\"} =\> part(1, \"/\", transformation) in {\"CBC\"};
	'  add constraint part(0, \"/\", transformation) in {\"BLOWFISH\"} =\> part(2, \"/\", transformation) in {\"NoPadding\"};
	'}" ;

test bool tc01() {
	ref1 = implode(#Refinement, parse(#RefinementDef, r1)); 
	ref2 = implode(#Refinement, parse(#RefinementDef, r2)); 
	ref3 = implode(#Refinement, parse(#RefinementDef, r3)); 
	
	res = mergeR(ref1, ref2); 
	
	
	return res == ref3; 
}	