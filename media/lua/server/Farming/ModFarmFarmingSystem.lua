require "Farming/SFarmingSystem"
require "Farming/SPlantGlobalObject"
require "Farming/farming_vegetableconf"
require "Farming/SPlantGlobalObject"


if isClient() then return end

function SFarmingSystem:growPlant(luaObject, nextGrowing, updateNbOfGrow)
	if(luaObject.state == "seeded") then
		local new = luaObject.nbOfGrow <= 0
		if luaObject.typeOfSeed ~= nil then
			if farming_vegetableconf.props[luaObject.typeOfSeed].growCode then
				local growCode = farming_vegetableconf.props[luaObject.typeOfSeed].growCode
				luaObject = assert(loadstring('return '..growCode..'(...)'))(luaObject, nextGrowing, updateNbOfGrow)
			end
		end

		if not new and luaObject.nbOfGrow > 0 then
			self:diseaseThis(luaObject, true)
		end
		luaObject.nbOfGrow = luaObject.nbOfGrow + 1
	end
end


function SFarmingSystem:harvest(luaObject, player)
	local props = farming_vegetableconf.props[luaObject.typeOfSeed]
	if props.harvestCode ~= nil then
			local harvestCode = props.harvestCode
			assert(loadstring('return '..harvestCode..'(...)'))(luaObject, player, self)
		return;
	end
	ModFarm.harvest(luaObject,player,self)
end


function SPlantGlobalObject:rottenThis()
	local texture = nil
	if self.typeOfSeed == "Carrots" then
		texture = "vegetation_farming_01_13"
	elseif self.typeOfSeed == "Broccoli" then
		texture = "vegetation_farming_01_23"
	elseif self.typeOfSeed == "Strawberry plant" then
		texture = "vegetation_farming_01_63"
	elseif self.typeOfSeed == "Radishes" then
		texture = "vegetation_farming_01_39"
	elseif self.typeOfSeed == "Tomato" then
		texture = "vegetation_farming_01_71"
	elseif self.typeOfSeed == "Potatoes" then
		texture = "vegetation_farming_01_47"
	elseif self.typeOfSeed == "Cabbages" then
		texture = "vegetation_farming_01_31"
	else
		texture = farming_vegetableconf.sprite[self.typeOfSeed][#farming_vegetableconf.sprite[self.typeOfSeed]]
	end
	self:setSpriteName(texture)
	self.state = "rotten"
	self:setObjectName(farming_vegetableconf.getObjectName(self))
	self:deadPlant()
end




-- TODO
--[[
-- lower by 1 the waterLvl of all our plant
function SPlantGlobalObject:lowerWaterLvl(plant)

	if self.waterLvl ~= nil then
		local waterChange = 1
		if plant.typeOfSeed and plant.typeOfSeed ~= "none" and farming_vegetableconf.props[plant.typeOfSeed].waterConsumption then
			waterChange = farming_vegetableconf.props[plant.typeOfSeed].waterConsumption;
		end
		-- flies make water dry more quickly, every 10 pts of flies, water lower by 1 more pts
		local waterFliesChanger = math.floor(self.fliesLvl / 10)
		self.waterLvl = self.waterLvl - waterChange - waterFliesChanger
		if self.waterLvl < 0 then
			self.waterLvl = 0
		end

	end
end
]]
