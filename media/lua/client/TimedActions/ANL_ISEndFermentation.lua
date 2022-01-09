--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISEndFermentation = ISBaseTimedAction:derive("ISEndFermentation");

function ISEndFermentation:isValid()
	return self.character:getInventory():contains(self.item) and ANL.Fermentation.isFermentable(self.item) and ANL.Fermentation.getFermentationProcess(self.item) >= 1.0
end

function ISEndFermentation:update()
	self.item:setJobDelta(self:getJobDelta());
end

function ISEndFermentation:start()
	self.item:setJobType(getText("ContextMenu_ANL_OnEndFermentation"));
	self.item:setJobDelta(0.0);
	self:setOverrideHandModels(nil, self.item)
	self:setActionAnim(CharacterActionAnims.Craft);
end

function ISEndFermentation:stop()
	self.item:setJobDelta(0.0);
	ISBaseTimedAction.stop(self);
end

function ISEndFermentation:perform()
    self.item:setJobDelta(0.0);
    self.item:getContainer():setDrawDirty(true);

	ANL.Fermentation.EndFermentation(self.item);

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISEndFermentation:new(character, item)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.item = item;
	o.stopOnWalk = false;
	o.stopOnRun = true;
	o.maxTime = 30;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o;
end
