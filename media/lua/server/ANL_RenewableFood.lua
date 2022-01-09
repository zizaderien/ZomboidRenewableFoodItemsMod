if not ANL then ANL = {} end
if not ANL.Fermentation then ANL.Fermentation = {} end
if not ANL.RF then ANL.RF = {} end

function anl_split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function ANL.Fermentation.isFermentable(item)
    return item:hasModData() and item:getModData().isFermentable == 1
end

function ANL.Fermentation.getFermentationProcess(item)
    local modData = item:getModData()
    return (getGameTime():getWorldAgeHours() - modData.fermentationStart) / (modData.daysToFerment * 24)
end

local function spawnResultItems(fermentedItem, resultNames)
    local modData = fermentedItem:getModData();
    local container = fermentedItem:getContainer();
    local worldItem = fermentedItem:getWorldItem();

    for _, itemName in pairs(resultNames) do
        local fullItemName = itemName
        if not string.find(fullItemName, "%.") then
            fullItemName = fermentedItem:getModule() .. "." .. fullItemName;
        end

        if worldItem then
            local square = worldItem:getSquare();
            square:AddWorldInventoryItem(fullItemName, worldItem:getX() % 1.0, worldItem:getY() % 1.0, worldItem:getZ() % 1.0);
            if container then
                container:setDirty(true);
                container:setDrawDirty(true);
            end
        elseif container then
            container:AddItem(fullItemName);
        end
    end

    if worldItem then
        square:transmitRemoveItemFromSquare(worldItem)
        square:getChunk():recalcHashCodeObjects();
        fermentedItem:setWorldItem(nil);
    end
    if container then
        container:DoRemoveItem(fermentedItem);
    end
end

function ANL.Fermentation.EndFermentation(item, successful)
    successful = successful or true
    if ANL.Fermentation.isFermentable(item) and successful then
        local func = _G
        local str = anl_split(item:getModData().onFermentationFinish, ".")
        for _, s in ipairs(str) do
            func = func[s]
        end
        func(item)
    end
end

function ANL.RF.VinegarFermented(item)
    spawnResultItems(item, {"Base.Vinegar", "Base.EmptyJar"})
end
function ANL.RF.BerriesFermented(item)
    spawnResultItems(item, {"ANL.WildBerryWine", "Base.JarLid"})
end
function ANL.RF.YeastFermented(item)
    spawnResultItems(item, {"Base.Yeast", "Base.JarLid", "Base.EmptyJar"})
end
