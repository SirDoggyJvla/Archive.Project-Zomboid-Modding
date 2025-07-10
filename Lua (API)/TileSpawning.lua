local square = YOUR_SQUARE_HERE or getPlayer():getSquare()
local sprite_type = "YOUR SPRITE NAME HERE AS IT APPEARS ON THE TILESHEET"
local newSprite = (IsoObject.new(getCell(), square, sprite_type))    
if not newSprite then
    print("NO NEW SPRITE!")
    return false
end    
if newSprite and newSprite:getProperties() then 
    if newSprite:getProperties():Val("ContainerType") or newSprite:getProperties():Val("container") then
            newSprite:createContainersFromSpriteProperties()                
    end
end
square:getObjects():add(newSprite)
square:RecalcProperties() 