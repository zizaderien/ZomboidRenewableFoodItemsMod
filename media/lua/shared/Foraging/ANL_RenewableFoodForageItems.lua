require "Foraging/forageSystem"

Events.onAddForageDefs.Add(function()

local SmallSaltRock = {
	type="ANL.SmallSaltRock",
	minCount=1,
	maxCount=3,
	xp=15,
	skill=3,
	categories = { "Stones" },
	zones={ Forest=25, DeepForest=25, FarmLand=20, Farm=15, Vegitation=30 },
	spawnFuncs = { doWildFoodSpawn }
};

forageSystem.addItemDef(SmallSaltRock);

end);
