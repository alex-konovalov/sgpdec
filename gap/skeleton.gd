################################################################################
##
## skeleton.gd           SgpDec package
##
## Copyright (C)  Attila Egri-Nagy, Chrystopher L. Nehaniv
##                James D. Mitchell
##
## The skeleton of a transformation semigroup: the set of images of
## the state set under the action of the semigroup, plus some useful
## relations on this image set.
##

###################################################
###SKELETON########################################
###################################################

DeclareInfoClass("SkeletonInfoClass");

#the constructor
DeclareOperation("Skeleton",[IsTransformationSemigroup]);
DeclareGlobalFunction("RepresentativeSet");
DeclareGlobalFunction("RepresentativesOnDepth");
DeclareGlobalFunction("ChangeRepresentativeSet");
DeclareGlobalFunction("AllRepresentativeSets");
DeclareGlobalFunction("IsEquivalent");
DeclareGlobalFunction("GetIN");
DeclareGlobalFunction("GetINw");
DeclareGlobalFunction("GetOUT");
DeclareGlobalFunction("GetOUTw");
DeclareGlobalFunction("CoveringSetsOf");
DeclareGlobalFunction("RandomCoverChain");
DeclareGlobalFunction("AllCoverChainsToSet");
DeclareGlobalFunction("AllCoverChains");
DeclareGlobalFunction("NumberOfCoverChainsToSet");
DeclareGlobalFunction("Permutators");
DeclareGlobalFunction("PermutatorGenerators");
DeclareGlobalFunction("CoverGroup");
DeclareGlobalFunction("DepthOfSkeleton");
DeclareGlobalFunction("TopSet");
DeclareGlobalFunction("DepthOfSet");
DeclareGlobalFunction("HeightOfSet");
DeclareGlobalFunction("ImageSets");
DeclareGlobalFunction("SkeletonClasses");
DeclareGlobalFunction("SkeletonClassesOnDepth");

# to be reimplemented
DeclareGlobalFunction("DotSkeleton");
DeclareGlobalFunction("DisplaySkeletonRepresentatives");
DeclareGlobalFunction("ActionMatrix");