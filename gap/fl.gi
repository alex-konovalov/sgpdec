# for a subgroupchain it calculates the right transversals and a group action on
# the cosets
# in Frobenius-Lagrange decompositions these are the coordinates and components
InstallGlobalFunction(CosetActionGroups,
function(subgroupchain)
local transversals, comps,i,compgens;
  transversals := [];
  comps := [];
  for i in [1..Length(subgroupchain)-1] do
    #the transversals - coset spaces
    transversals[i] := RightTransversal(subgroupchain[i],subgroupchain[i+1]);
    #the generators of the component by the canonical action on the cosets
    compgens := List(GeneratorsOfGroup(subgroupchain[i]),
                     gen -> AsPermutation(
                             TransformationOp(gen,transversals[i],OnRight)));
    #getting rid of identity permutations
    compgens := Filtered(compgens, gen-> not IsOne(gen));
    #getting rid of duplicate generators, creating the groups
    Add(comps,Group(AsSet(compgens)));
  od;
  return rec(transversals:=transversals,components:=comps);
end);

InstallGlobalFunction(FLCascadeGroup,
function(group_or_chain)
  local gens,id,cosetactions,G,flG;
  if IsGroup(group_or_chain) then
    cosetactions := CosetActionGroups(ChiefSeries(group_or_chain));
    G := group_or_chain;
  elif IsListOfPermGroups(group_or_chain) then
    cosetactions := CosetActionGroups(group_or_chain);
    G := group_or_chain[1];
  else
    ;#TODO usage message
  fi;
  id := IdentityCascade(cosetactions.components);
  flG := Group(List(GeneratorsOfGroup(G),
                 g->Cascade(cosetactions.components,
                         FLDependencies(g,
                                 cosetactions.transversals,
                                 DomainOf(id)))));
  SetIsFLCascadeGroup(flG,true);
  SetTransversalsOf(flG, cosetactions.transversals);
  return flG;
end);

InstallMethod(IsomorphismPermGroup, "for a Frobenius-Lagrange cascade group",
[IsFLCascadeGroup],
function(G)
  local H;
  H:=Group(List(GeneratorsOfGroup(G), AsPermutation));
  return MagmaIsomorphismByFunctionsNC(
                 G,
                 H,
                 AsPermutation,
                 f -> AsCascade(f, ComponentDomains(G)));
end);

# what group elements correspond to the integers
StabilizerCosetActionReps := function(G)
local stabrt, stabrtreps,i;
  stabrt := RightTransversal(G,Stabilizer(G,1));
  stabrtreps := [];
  for i in [1..Length(stabrt)] do
    stabrtreps[1^stabrt[i]] := stabrt[i];
  od;
  return stabrtreps;
end;

# getting the representative of an element
CosetRep := function(g,transversal)
  return transversal[PositionCanonical(transversal,g)];
end;

#coding the coset representatives to the their integer indices
# TODO this seems to do two things, converting to coset reps as well
# but that may be needed, then it is a misnomer
# OK, fix was done below, still misnomer
EncodeCosetReprs := function(list, transversals)
  return List([1..Size(list)],
              i -> PositionCanonical(transversals[i], list[i]));
                      #CosetRep(list[i],transversals[i])));
end;

# decoding the integers back to coset rep
DecodeCosetReprs := function(cascstate, transversals)
  return List([1..Size(cascstate)],
              i -> transversals[i][cascstate[i]]);
end;

# Each cascaded state corresponds to one element (in the regular representation)
#of the group. This function gives the path corresponding to a group element
#(through the Lagrange-Frobenius map).
Perm2Coords := function(g, transversals)
local coords,i;
  #on the top level we have simply g
  coords := [g];
  #then going down to deeper levels
  for i in [1..Length(transversals)-1] do
    Add(coords, coords[i] * Inverse(CosetRep(coords[i],transversals[i])));
  od;
  #taking the representative elements then coding coset reps as points (indices)
  return EncodeCosetReprs(coords, transversals);
end;

#mapping down is just multiplying together
Coords2Perm := function(cs, transversals)
    return Product(Reversed(DecodeCosetReprs(cs, transversals)),());
end;

# s - state (list), g - group element to be lifted,
InstallGlobalFunction(FLComponentActions,
function(g,s, transversals)
  local fudges,i;
  s := DecodeCosetReprs(s,transversals);
  #on the top level we have simply g
  fudges := [g];
  #then going down to deeper levels
  for i in [2..Length(s)] do
    Add(fudges,
        s[i-1] * #this is already a representative!
        fudges[i-1] *
        Inverse(CosetRep(s[i-1] * fudges[i-1],
                transversals[i-1])));
  od;
  #converting to coset action
  return List([1..Length(fudges)],
              i -> AsPermutation(
                      TransformationOp(fudges[i],transversals[i],\*)));
end);

InstallGlobalFunction(FLDependencies,
function(g,transversals, dom)
local i,state,actions,depfuncs;
  #identity needs no further calculations
  if g=() then return [];fi;
  depfuncs := [];
  #we go through all states
  for state in dom do
    #get the component actions on a state
    actions := FLComponentActions(g,state,transversals);
    #examine whether there is a nontrivial action, then add
    for i in [1..Length(actions)] do
      if actions[i] <> () then
        AddSet(depfuncs,[state{[1..(i-1)]},actions[i]]);
      fi;
    od;
  od;
  return depfuncs; #TODO maybe sort them into a graded list
end);
