#############################################################################
##
## cascadeshell.gi           SgpDec package
##
## Copyright (C) 2008-2012
##
## Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## An empty shell defined by an ordered list of components.
## Used for defining cascaded structures.
##

###UTIL FUNCTIONS FOR THE MAIN CONSTRUCTOR

# Constructing a short name for a component
# 1. If it has a name just return it.
# 2. For a group when the Small Group's Library allowed, then use that
# 3. Otherwise S_order for semigroups, G_order for groups
Name4Component := function(comp)
  if HasName(comp) then
    return Name(comp);
  fi;

  if IsGroup(comp) then
    if SgpDecOptionsRec.SMALL_GROUPS then
      return StructureDescription(comp);
    else
      return Concatenation("G",StringPrint(Order(comp)));
    fi;
  else
    return Concatenation("S",StringPrint(Size(comp)));
  fi;
end;

InstallMethod(IsCascadedGroupShell,[IsCascadeShell],
csh -> ForAll(csh!.components, IsGroup));

# SIMPLIFIED CONSTRUCTOR
# calling the main with default identity functions
InstallOtherMethod(CascadeShell,[IsList],
function(components)
local statesym, opsym, comp,gid;

  statesym := [];
  opsym := [];
  for comp in components do
     Add(statesym, x->x);
     Add(opsym, function(x)
       if IsTransformation(x) then
         return SimplerLinearNotation(x);
       else
         return x; fi;end);
  od;
  return CascadeShell(components,statesym,opsym);
end);

#THE MAIN CONSTRUCTOR with all the possible arguments
InstallMethod(CascadeShell,[IsList,IsList,IsList],
function(components,statesymbolfunctions,operationsymbolfunctions)
local cascprodinfo,prodname,i,str,result,state_set_sizes;

  #GENERATING THE NAME
  #deciding whether it is a group or not and set the name accordingly
  if ForAll(components, IsGroup) then
    prodname := "G";
  else
    prodname := "S";
  fi;
  #concatenating component names
  Perform(components,
          function(c)
            prodname := Concatenation(prodname,"_", Name4Component(c));
          end);

  #BUILDING THE INFO RECORD
  #this is the main record containing information about the cascade product,
  #the initial values do not matter
  cascprodinfo := rec(
                      state_symbol_functions := statesymbolfunctions,
                      operation_symbol_functions := operationsymbolfunctions,
                      components := components,
                      name_of_product := prodname);

  #guessing the statesets of the original components
  cascprodinfo.state_sets := []; #TODO this will be replaced by LambdaDomain
  for i in components do
    if IsGroup(i) then
      Add(cascprodinfo.state_sets,MovedPoints(i));
    else
      Add(cascprodinfo.state_sets,
          [1..DegreeOfTransformation(Representative(i))]);
    fi;
  od;

  #calculating the maximal number of elementary dependencies
  state_set_sizes := List(cascprodinfo.state_sets, x-> Size(x));
  cascprodinfo.maxnum_of_dependency_entries :=
    Sum(List([1..Size(components)], x-> Product(state_set_sizes{[1..x-1]})));

  #constructing argumentnames (for display purposes)
  cascprodinfo.argument_names := [];
  cascprodinfo.argument_names[1] := "{}"; #the empty set
  str := "";
  for i in [2..Length(components)] do
      if i > 2 then str  := Concatenation(str, " x ");fi;
      str := Concatenation(str,StringPrint(Size(cascprodinfo.state_sets[i-1])));
      cascprodinfo.argument_names[i] := str;
  od;

  #creating cascade state typed states
  #GENERATING STATES
  cascprodinfo.states := EnumeratorOfCartesianProduct(cascprodinfo.state_sets);

  result :=  Objectify(CascadeShellType,cascprodinfo);

  #making it immutable TODO this may not work
  cascprodinfo := Immutable(cascprodinfo);

  return result;
end);

#######################ACCESS METHODS#######################
InstallGlobalFunction(States,
function(csh) return csh!.states; end);

InstallGlobalFunction(StateSets,
function(csh) return csh!.state_sets; end);

InstallGlobalFunction(MaximumNumberOfElementaryDependencies,
function(csh) return csh!.maxnum_of_dependency_entries; end);

InstallOtherMethod(Name,"for cascade shells",[IsCascadeShell],
function(csh) return csh!.name_of_product; end);

#this is a huge number even in small cases
InstallGlobalFunction(SizeOfWreathProduct,
function(csh)
local order,j,i;
  #calculating the order of the cascaded state set
  order := 1;
  #j is the number of possible arguments on a given depth, i.e.\ the exponent
  j := 1;
  for i in [1..Size(csh)] do
    order := order * (Size(csh[i])^j);
    j := j * Size(StateSets(csh)[i]);
  od;
  return order;
end);

#######################OLD METHODS#############################
# The size of the cascade shell is the number components.
InstallMethod(Length,"for cascade shells",true,[IsCascadeShell],
function(csh)
  return Length(csh!.components);
end
);

# for accessing the list elements
InstallOtherMethod( \[\],
    "for cascade shells",
    [ IsCascadeShell, IsPosInt ],
function( csh, pos )
return csh!.components[pos];
end);

#############################################################################
# Implementing Display, printing nice, human readable format.
InstallMethod( ViewObj,
    "displays a cascade shell",
    true,
    [IsCascadeShell], 0,
function(csh)
local s,i;
  s := "";
  for i in [1..Length(csh)] do
    Print(i," ", s, Size(StateSets(csh)[i])," ");
    ViewObj(csh[i]);
    Print("\n");
    s := Concatenation(s,"|-");
  od;
end);