#############################################################################
##
## cascadeshell.gd           SgpDec package
##
## Copyright (C) 2008-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## An empty shell defined by an ordered list of components.
## Used for defining cascaded structures.
##

DeclareGlobalFunction("CascadeProduct");
DeclareSynonymAttr("IsCascadeProduct", IsSemigroup and
        IsCascadedTransformationCollection);

DeclareAttribute("DomainsOfCascadeProductComponents", IsCascadeProduct);
DeclareAttribute("CascadeProductComponents" IsCascadeProduct);
DeclareAttribute("DomainOfCascadeProduct", IsCascadeProduct);


#DeclareRepresentation("IsCascadedStructureRep", 
#IsComponentObjectRep and IsAttributeStoringRep and IsSemigroup, 
#[ "components", # the underlying perm groups or transformation semigroups
#  "domains",    # the domains of the actions of the underlying semigroups
#  "enum"       # enumerator of the domain of the wreath product
#]);

DeclareOperation("CascadeShell",[IsList,IsList,IsList]);
DeclareGlobalFunction("AllCoords");
DeclareGlobalFunction("CoordValSets");
DeclareGlobalFunction("NameOfDependencyDomain");
DeclareGlobalFunction("CoordValConverter");
DeclareGlobalFunction("CoordTransConverter");
DeclareGlobalFunction("SizeOfWreathProduct");
DeclareGlobalFunction("NumberOfDependencyFunctionArguments");

DeclareCategory("IsCascadeShell", IsDenseList);
DeclareProperty("IsCascadedGroupShell", IsCascadeShell);
DeclareRepresentation(
        "IsCascadeShellRep",
        IsComponentObjectRep,
        [ "components", #the building blocks
          "name_of_shell", #a short name constructed from the components
          "coordval_converters", #functions for convert coord vals (e.g. names)
          "coordtrans_converters", #functions for converting coord trans
          "depdom_names", #the names of dependency domains
          "coordval_sets", #coordinate values (the original statesets of comps)
          "allcoords", #all coordinate tuples (lazy storage)
          "num_of_dependency_entries" #number of distinct dep function arguments
          ]);
CascadeShellType :=
  NewType(NewFamily("CascadeShellFamily",IsCascadeShell),
          IsCascadeShell and IsCascadeShellRep);
