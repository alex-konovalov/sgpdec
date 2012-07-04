
######################################################
TestMultiplicationByIdentity := function(cascprodinfo)
local i,id,rnd;
id := IdentityCascadedOperation(cascprodinfo);
Print("Random operations multiplied by identity (testing =,*)\n");
for i in [1..333] do
  rnd := RandomCascadedOperation(cascprodinfo,13);
  if ((rnd*id) <> rnd) or (rnd <> (id*rnd)) then 
      Print("FAIL\n");Error("Operation combined with identity does not equal itself!\n"); 
  else
      Print("#\c");
  fi;
od;
Print("\nPASSED\n");
end;;
