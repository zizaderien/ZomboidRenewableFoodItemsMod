local fermentationTable = {};

local function loadItemIfFermentable(item)
    -- Check is fermentable
    if not item:hasTag("Fermentable") then return end
    if fermentationTable[item:getID()] ~= nil then return end

    if item:getModData().daysToFerment == nil or item:getModData().onFermentedItem == nil then
        ANL_Error_FermentableItemHasMissingParameters(item); -- Some weird way to throw assert
    end
    if item:getModData().fermentationStart == nil then
        item:getModData().fermentationStart = getGameTime():getWorldAgeHours();
    end

    fermentationTable[item:getID()] = item;

end

function ANL_BeginFermentation(item)
    loadItemIfFermentable(item)
end

function ANL_isFermentable(item)
    return item:hasTag("Fermentable")
end

function ANL_EndFermentation(item, successful)
    successful = successful or true
    local modData = item:getModData();
    local item_id = item:getID()
    if fermentationTable[item_id] ~= nil then
        if successful then
            local newItemName = modData.onFermentedItem;
            local newItemName2 = nil
            if not string.find(newItemName, "%.") then
                newItemName = item:getModule() .. "." .. newItemName;
            end
            if modData.onFermentedItem2 then
                newItemName2 = modData.onFermentedItem2;
                if not string.find(newItemName2, "%.") then
                    newItemName2 = item:getModule() .. "." .. newItemName2;
                end
            end
            local container = item:getContainer();
            local worldItem = item:getWorldItem();

            if worldItem ~= nil then
                local square = worldItem:getSquare();
                square:AddWorldInventoryItem(newItemName, worldItem:getX() % 1.0, worldItem:getY() % 1.0, worldItem:getZ() % 1.0);
                if modData.onFermentedItem2 then
                    square:AddWorldInventoryItem(newItemName2, worldItem:getX() % 1.0, worldItem:getY() % 1.0, worldItem:getZ() % 1.0)
                end
                square:transmitRemoveItemFromSquare(worldItem);
                if container ~= nil then
                    container:setDirty(true);
                    container:setDrawDirty(true);
                end
                square:getChunk():recalcHashCodeObjects();
                item:setWorldItem(nil);
            else
                container:AddItem(newItemName);
                if modData.onFermentedItem2 then
                    container:AddItem(newItemName2);
                end
            end
            container:DoRemoveItem(item);
        end
        fermentationTable[item_id] = nil
    end
end

function ANL_ReloadFermentation(item)
    loadItemIfFermentable(item)
end

Events.EveryHours.Add(function()
    for k,v in pairs(fermentationTable) do
        local modData = v:getModData();
        if modData.fermentationStart + modData.daysToFerment * 24 <= getGameTime():getWorldAgeHours() then
            ANL_EndFermentation(v, true);
        end
    end
end);

local function loadFermentableItems(container)
    local items = container:getAllTagRecurse("Fermentable", ArrayList.new());
    for i1 = 0, items:size() - 1, 1 do
        loadItemIfFermentable(items:get(i1));
    end
end

anl_total1 = 0
anl_total2 = 0
anl_total3 = 0
anl_total4 = 0
anl_total5 = 0

anl_cars = {}
anl_cars_len = 0

Events.OnCreatePlayer.Add(function(playerIndex, player)
    loadFermentableItems(player:getInventory())
end);

Events.LoadGridsquare.Add(function(square)
    if square == nil or not instanceof(square, "IsoGridSquare") then return end

    if square:getStaticMovingObjects() ~= nil and square:getStaticMovingObjects():size() > 0 then
        -- Static moving check
        for i1 = 0, square:getStaticMovingObjects():size() - 1, 1 do
            local v = square:getStaticMovingObjects():get(i1);
            local container = v:getContainer();
            if container ~= nil then
                loadFermentableItems(container)
                anl_total1 = anl_total1 + 1; -- TODO: Убрать
            end
        end
    end
    if square:getObjects() ~= nil and square:getObjects():size() > 0 then
        for i1 = 0, square:getObjects():size() - 1, 1 do
            local v = square:getObjects():get(i1);
            for ind = 0, v:getContainerCount() - 1, 1 do
                local container = v:getContainerByIndex(ind);
                if container ~= nil then
                    loadFermentableItems(container)
                    anl_total2 = anl_total2 + 1; -- TODO: Убрать
                end
            end
        end
    end
    if square:getWorldObjects() ~= nil and square:getWorldObjects():size() > 0 then
        for i1 = 0, square:getWorldObjects():size() - 1, 1 do
            local item = square:getWorldObjects():get(i1):getItem();
            if item ~= nil then
                loadItemIfFermentable(item)
                if instanceof(item, "InventoryContainer") then
                    loadFermentableItems(item:getInventory());
                    anl_total3 = anl_total3 + 1; -- TODO: Убрать
                end
            end
        end
    end

    --if anl_cars_len ~= getCell():getVehicles():size() then
    --    --anl_total5 = anl_total5 + 1; -- TODO: Убрать
    --end
    --for i1 = 0, getCell():getVehicles():size() - 1, 1 do
    --    if anl_cars[i1] ~= getCell():getVehicles():get(i1) then
    --        anl_cars = {}
    --        for i2 = 0, getCell():getVehicles():size() - 1, 1 do
    --            local vehicle = getCell():getVehicles():get(i2)
    --            anl_cars[i2] = vehicle
    --            for i3 = 0, vehicle:getPartCount() - 1, 1 do
    --                local part = vehicle:getPartByIndex(i2)
    --                if part ~= nil and part:getItemContainer() ~= nil then
    --                    loadFermentableItems(part:getItemContainer())
    --                    anl_total5 = anl_total5 + 1; -- TODO: Убрать
    --                end
    --            end
    --        end
    --        break
    --    end
    --end

    local vehicle = square:getVehicleContainer()
    if vehicle ~= nil then
        for i2 = 0, vehicle:getPartCount() - 1, 1 do
            local part = vehicle:getPartByIndex(i2)
            if part ~= nil and part:getItemContainer() ~= nil then
                loadFermentableItems(part:getItemContainer())
                anl_total4 = anl_total4 + 1; -- TODO: Убрать
            end
        end
    end

end);
