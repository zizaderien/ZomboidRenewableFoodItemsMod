local fermentationTable = {}

function ANL_BeginFermentation(item, resultName)
    local modData = item:getModData();
    modData.isFermentable = 1;
    modData.fermentation = 0;
    modData.onFermentedItem = resultName;
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
                print("Name ", newItemName)
                if not string.find(newItemName, "%.") then
                    print("Dot not found")
                    newItemName = item:getModule() .. "." .. newItemName;
                end
                print("Final name", newItemName)
                container:AddItem(newItemName);
                container:DoRemoveItem(item);
                --item:setContainer(nil);
            end
            modData.isFermentable = 0;
            modData.onFermentedItem = nil;
            fermentationTable[k] = nil
        end
    end
end

Events.EveryHours.Add(function()

    for k,v in pairs(fermentationTable) do
        local modData = v:getModData();
        modData.fermentation = modData.fermentation + 0.0002f;
        print("Age", v:getAge())
        if modData.fermentation > 0.97f then
            ANL_EndFermentation(v, true);
        end
    end

end);
