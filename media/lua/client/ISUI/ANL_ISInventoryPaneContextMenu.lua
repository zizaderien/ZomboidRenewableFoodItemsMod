require "ISUI/ISInventoryPaneContextMenu"

ISInventoryPaneContextMenu.onEndFermentation = function(fermentatedItem, player)
    local playerObj = getSpecificPlayer(player)
    if fermentatedItem:getContainer() == nil then
		return
	end
    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, fermentatedItem)
    ISTimedActionQueue.add(ISEndFermentation:new(playerObj, fermentatedItem))
end

Events.OnFillInventoryObjectContextMenu.Add(function(player, table, items)
    --print("TEST")
    local item = nil
    for i,v in ipairs(items) do
        if instanceof(v, "InventoryItem") then
            item = v
        else
            item = v.items[1];
        end
        if not (item:hasModData() and ANL.Fermentation.isFermentable(item) and ANL.Fermentation.getFermentationProcess(item) >= 1.0) then return end
    end
    table:addOption(getText("ContextMenu_ANL_OnEndFermentation"), item, ISInventoryPaneContextMenu.onEndFermentation, player)
    --print("ALL GOOD")

end)
