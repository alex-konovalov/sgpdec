#############################################################################
##
## depfunc.gi           SgpDec package
##
## (C)  Attila Egri-Nagy, Chrystopher L. Nehaniv, James D. Mitchell
##
## 2008-2012
##
## Dependency function.
##

## NAMING CONVENTIONS
## deparg - dependency argument, a tuple of states (formerly prefix)
## dom - domain of dependency function
## deps - list of dependecies in the [arg, value] format
## depdoms - dependency domains, i.e. domains of dependency functions

################################################################################
# CONSTRUCTORS #################################################################
################################################################################

# constructor for dependency functions
# input: domain and list of dependencies
InstallGlobalFunction(DependencyFunction,
function(dom, deps)
  local record,depdoms,vals,d;
  #this is a subtle issue: we need an element in the domain, even on the top
  if IsEmpty(dom) then
    dom := [[]];
  fi;
  #depdoms:=CreateDependencyDomains(doms);
  vals:=EmptyPlist(Length(dom));
  for d in deps do
    #vals[Length(d[1])+1][Position(depdoms[Length(d[1])+1], d[1])]:=d[2];
    vals[Position(dom,d[1])] := d[2];
  od;
  ShrinkAllocationPlist(vals);
  return CreateDependencyFunction(dom, vals);
end);

# just creating an instance when you know the internals
InstallGlobalFunction(CreateDependencyFunction,
function(dom, vals)
  MakeImmutable(vals); #just to be on the safe side
  return Objectify(DependencyFunctionType,rec(dom:=dom,vals:=vals));
end);

# Creates the list of all dependency domains of given sizes.
# These are the arguments of the dependency functions on each level.
# doms: list of pos ints or actual domains, integer x is converted to [1..x]
InstallGlobalFunction(DependencyDomains,
function(doms)
  local depdoms, tup, i;
  #converting integers to actual domains
  doms := List(doms,
               function(x) if IsPosInt(x) then return [1..x];
                           else return x; fi;end);
  #converting to domains if semigroups/groups
  if IsSemigroup(doms[1]) then
    doms := ComponentDomains(doms);
  fi;
  #JDM Why +1? To avoid reallocation?
  depdoms:=EmptyPlist(Length(doms)+1);
  #the top level depdoms is just the empty list
  depdoms[1]:=[[]];
  tup:=[]; #we add the components one by one
  for i in [1..Length(doms)-1] do
    Add(tup, doms[i]);
    Add(depdoms, EnumeratorOfCartesianProduct(tup));
  od;
  return depdoms;
end);

# distributing dependencies into individual dependency functions
InstallGlobalFunction(Deps2DepFuncs,
function(depdoms, deps)
local dep, vals, level;
  vals := List([1..Size(depdoms)], x->[]);
  for dep in deps do
    level := Size(dep[1])+1;
    vals[level][Position(depdoms[level],dep[1])] := dep[2];
  od;
  return List([1..Size(depdoms)],
              x -> CreateDependencyFunction(depdoms[x],vals[x]));
end);

InstallGlobalFunction(Dependencies,
function(df)
  local deps,i,dom,vals;
  vals := df!.vals;
  dom := df!.dom;
  deps := [];
  for i in [1..Size(vals)] do
    if IsBound(vals[i]) then
      Add(deps, [dom[i], vals[i]]);
    fi;
  od;
  return deps;
end);

################################################################################
# ATTRIBUTES ###################################################################
################################################################################

InstallMethod(NrDependencies, "for a dependency function",
[IsDependencyFunc],
function(f)
  return Number([1..Length(f!.vals)], i-> IsBound(f!.vals[i]));
end);

###############################################################################
# STANDARD METHODS ############################################################
###############################################################################

InstallMethod(\=, "for depfunc and depfunc", IsIdenticalObj,
[IsDependencyFunc, IsDependencyFunc],
        function(p,q)
  local i, pvals, qvals;
  #local variables for speeding up record member access
  pvals := p!.vals;
  qvals := q!.vals;
  if IsEmpty(pvals) and IsEmpty (qvals) then return true; fi;
  for i in [1..Size(p!.dom)] do
    if (not IsBound(pvals[i])) and (not IsBound(qvals[i])) then
      break; # that is good
    fi;
    if IsBound(pvals[i]) and IsBound(qvals[i]) and  pvals[i] = qvals[i] then
      break; #that's also good
    fi;
    return false;
  od;
  return true;
end);

InstallMethod(\<, "for depfunc and depfunc", IsIdenticalObj,
[IsDependencyFunc, IsDependencyFunc],
        function(p,q)
  local pval, qval,i;
  #first compare the domains
  if p!.dom <> q!.dom then return p!.dom < q!.dom; fi;
  for i in [1..Size(p!.dom)] do
    if IsBound(p!.vals[i]) then
      pval := p!.vals[i];
    else
      pval := ();
    fi;
    if IsBound(q!.vals[i]) then
      qval := q!.vals[i];
    else
      qval := ();
    fi;
    if pval < qval then
      return true;
    else
      return false;
    fi;
  od;
end);


################################################################################
# ACTION #######################################################################
################################################################################

InstallGlobalFunction(OnDepArg,
function(deparg, depfunc)
  local vals, dom, i, pos;
  vals:=depfunc!.vals;
  dom:=depfunc!.dom;
  #if the argument is not in the domain
  if not(deparg in dom) then return fail; fi;
  #searching for the position of the argument tuple
  pos:=Position(dom, deparg);
  #the default value is the identity
  if not IsBound(vals[pos]) then
    return ();
  fi;
  return vals[pos];
end);

# applying to a tuple (deparg) gives the corresponding value
InstallOtherMethod(\^, "for dependency argument and dependency func",
[IsList, IsDependencyFunc], OnDepArg);

################################################################################
# PRINTING #####################################################################
################################################################################

InstallMethod(ViewObj, "for a dependency func",
[IsDependencyFunc],
function(x) Print("<dependency function, ",
        String(NrDependencies(x))," deps>"); return; end);

InstallMethod(Display, "for a dependency function",
[IsDependencyFunc],
function(df)
  local vals, dom, i;
  vals := df!.vals;
  dom := df!.dom;
  for i in [1..Size(vals)] do
    if IsBound(vals[i]) then
      Print(String(dom[i])," -> ");
      #TODO String(vals[i][j]) return <object>
      Display(vals[i]);
    fi;
  od;
  return;
end);