local fermentationTable = {}

function ANL_BeginFermentation(item)
    local modData = item:getModData();
    modData.isFermentable = 1;
    modData.fermentation = 0;
    table.insert(fermentationTable, item);
end

function ANL_EndFermentation(item, successful)
    successful = successful or true
    local modData = item:getModData();
    for k,v in pairs(fermentationTable) do
        if v == item then
            if successful then
                local container = item:getContainer();
                local newItemName = modData.onFermentedItem;
                if not string.find(newItemName, "%.") then
                    newItemName = item:getModule() .. "." .. newItemName;
                end
                container:AddItem(newItemName);

                if(modData.onFermentedItem2) then
                    newItemName = modData.onFermentedItem2;
                    if not string.find(newItemName, "%.") then
                        newItemName = item:getModule() .. "." .. newItemName;
                    end
                    container:AddItem(newItemName);
                end

                container:DoRemoveItem(item);
                --item:setContainer(nil);
            end
            modData.isFermentable = 0;
            fermentationTable[k] = nil
        end
    end
end

Events.EveryHours.Add(function()

    for k,v in pairs(fermentationTable) do
        local modData = v:getModData();
        modData.fermentation = modData.fermentation + 1/(modData.daysToFerment*24);
        if modData.fermentation > 0.99f then
            ANL_EndFermentation(v, true);
        end
    end

end);
