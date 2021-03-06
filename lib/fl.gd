#############################################################################
##
## fl.gd           SgpDec package
##
## Copyright (C) 2008-2019
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## Frobenius-Lagrange decomposition. Cascade groups built from components
## acting on coset spaces determined by a subgroup chain.
##

DeclareProperty("IsFLCascadeGroup",IsCascadeGroup);

DeclareGlobalFunction("FLCascadeGroup");
DeclareGlobalFunction("CosetActionGroups");
DeclareGlobalFunction("FLDependencies");
DeclareGlobalFunction("FLComponentActions");
DeclareGlobalFunction("AsFLPoint");
DeclareGlobalFunction("AsFLCoords");
DeclareGlobalFunction("Perm2Coords");
DeclareGlobalFunction("Coords2Perm");
DeclareGlobalFunction("LevelKillers");
DeclareGlobalFunction("LevelBuilders");

DeclareAttribute("TransversalsOf", IsFLCascadeGroup);
DeclareAttribute("OriginalCosetActionRepsOf", IsFLCascadeGroup);
