require 'Items/ProceduralDistributions'

function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";


-- Renewable Food
registerAsLoot("ANL.AnlRenewMag1", 0.8, "BookstoreBooks");
registerAsLoot("ANL.AnlRenewMag1", 0.2, "PostOfficeBooks");
registerAsLoot("ANL.AnlRenewMag1", 0.7, "LibraryBooks");
registerAsLoot("ANL.AnlRenewMag1", 1, "LivingRoomShelf");
registerAsLoot("ANL.AnlRenewMag1", 0.1, "ClassroomShelves");
registerAsLoot("ANL.AnlRenewMag1", 0.1, "ClassroomMisc");
registerAsLoot("ANL.AnlRenewMag1", 0.5, "MagazineRackMixed");

registerAsLoot("ANL.AnlRenewMag2", 0.8, "BookstoreBooks");
registerAsLoot("ANL.AnlRenewMag2", 0.2, "PostOfficeBooks");
registerAsLoot("ANL.AnlRenewMag2", 0.7, "LibraryBooks");
registerAsLoot("ANL.AnlRenewMag2", 1, "LivingRoomShelf");
registerAsLoot("ANL.AnlRenewMag2", 0.8, "GigamartFarming");
registerAsLoot("ANL.AnlRenewMag2", 0.1, "ClassroomShelves");
registerAsLoot("ANL.AnlRenewMag2", 0.1, "ClassroomMisc");
registerAsLoot("ANL.AnlRenewMag2", 0.5, "MagazineRackMixed");

registerAsLoot("ANL.SugarBeetBagSeed", 4, "CrateFarming");
registerAsLoot("ANL.SugarBeetBagSeed", 10, "GardenStoreMisc");
registerAsLoot("ANL.SugarBeetBagSeed", 4, "GigamartFarming");
registerAsLoot("ANL.SugarBeetBagSeed", 3, "ToolStoreFarming");

-- Yeast jar return
function Recipe.OnCreate.OpenYeastJar (items, result, player)	
  local inv = player:getInventory();	
  inv:AddItem("Base.EmptyJar");	
  inv:AddItem("Base.JarLid");	
end 