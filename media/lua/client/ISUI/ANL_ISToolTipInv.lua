local stock_ISTolTipInv_render = ISToolTipInv.render;

local function drawFermentationTooltip(tooltip, fermentation)
    local layout = tooltip:beginLayout();
    local fermentationBar = layout:addItem();
    fermentationBar:setLabel(Translator.getText("Tooltip_ANL_fermentation"), 1.0f, 1.0f, 0.8f, 1.0f);
    fermentationBar:setProgress(fermentation, 0.0f, 0.6f, 0.0f, 0.7f)
    local render = layout:render(5, 5 + 2*(tooltip:getLineSpacing() + 5), tooltip);
    tooltip:endLayout(layout);
    tooltip:setHeight(render + 5);
end

function ISToolTipInv:render()
    if not self.item:hasModData() then
        return stock_ISTolTipInv_render(self);
    end

    local modData = self.item:getModData();
    if not modData.isFermentable then
        return stock_ISTolTipInv_render(self);
    end

    -- Tooltip for fermentable item
    if ISContextMenu.instance and ISContextMenu.instance.visibleCheck then return end
    local mx = getMouseX() + 24;
    local my = getMouseY() + 24;
    if not self.followMouse then
       mx = self:getX()
       my = self:getY()
       if self.anchorBottomLeft then
           mx = self.anchorBottomLeft.x
           my = self.anchorBottomLeft.y
       end
    end

    self.tooltip:setX(mx+11);
    self.tooltip:setY(my);

    self.tooltip:setWidth(50)
    self.tooltip:setMeasureOnly(true)
    self.item:DoTooltip(self.tooltip);
    drawFermentationTooltip(self.tooltip, modData.fermentation)
    self.tooltip:setMeasureOnly(false)

    local myCore = getCore();
    local maxX = myCore:getScreenWidth();
    local maxY = myCore:getScreenHeight();

    local tw = self.tooltip:getWidth();
    local th = self.tooltip:getHeight();

    self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)));
   if not self.followMouse and self.anchorBottomLeft then
       self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)));
   else
       self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)));
   end

    self:setX(self.tooltip:getX() - 11);
    self:setY(self.tooltip:getY());
    self:setWidth(tw + 11);
    self:setHeight(th);

   if self.followMouse then
       self:adjustPositionToAvoidOverlap({ x = mx - 24 * 2, y = my - 24 * 2, width = 24 * 2, height = 24 * 2 })
   end

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
    self.item:DoTooltip(self.tooltip);

    drawFermentationTooltip(self.tooltip, modData.fermentation)
end


    --local modData = item:getModData();
