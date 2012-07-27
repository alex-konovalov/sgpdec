#############################################################################
##
## words.gd           SgpDec package
##
## Copyright (C) 2010-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## Algorithms with words.
##

#words consisting of positive integers only (no inverse operation)
DeclareGlobalFunction("Construct");
DeclareGlobalFunction("Trajectory");
DeclareGlobalFunction("IsStraightWord");
DeclareGlobalFunction("Reduce2StraightWord");
DeclareGlobalFunction("RandomWord");

#enumerating straight words
DeclareGlobalFunction("AllStraightWords");
DeclareGlobalFunction("StraightWords");
#straight word processors
DeclareGlobalFunction("SWP_Print");

DeclareInfoClass("StraightWordsInfoClass");