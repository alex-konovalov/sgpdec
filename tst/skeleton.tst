# testing holonomy  decomposition
gap> START_TEST("Sgpdec package: skeleton.tst");
gap> LoadPackage("sgpdec", false);;
gap> sk := Skeleton(FullTransformationSemigroup(5));;
gap> IsSubductionLessOrEquivalent(sk,FiniteSet([1,3,5],5), FiniteSet([2],5));
false
gap> IsSubductionLessOrEquivalent(sk,FiniteSet([1],5), FiniteSet([2,4,5],5));
true

#becks
gap> gens := [
> Transformation([1,2,3,1,1,1]), Transformation([4,4,4,5,4,6]),
> Transformation([4,4,4,5,6,4]), Transformation([4,4,4,4,5,5]),
> Transformation([4,4,4,1,2,3]), Transformation([2,3,1,4,4,4])];;
gap> sk := Skeleton(Semigroup(gens));;
gap> P := FiniteSet([4,5],6);;
gap> Q := FiniteSet([3,4],6);;
gap> IsSubsetBlist(OnFiniteSet(Q, EvalWordInSkeleton(sk,
>        SubductionWitness(sk,P,Q))),P);
true

#number of tile chains
gap> d := DegreeOfSkeleton(sk);;
gap> ForAll([1..d], x -> NrChainsBetween(sk,BaseSet(sk),FiniteSet([x],d)) = Size(ChainsBetween(sk, BaseSet(sk),FiniteSet([x],d))));
true

#
gap> STOP_TEST( "Sgpdec package: skeleton.tst", 10000);
