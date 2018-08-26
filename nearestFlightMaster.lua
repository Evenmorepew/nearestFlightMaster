function()
    local bestMap = C_Map.GetBestMapForUnit("player");
    local nodes = C_TaxiMap.GetTaxiNodesForMap(bestMap);
    
    local mp = C_Map.GetPlayerMapPosition(bestMap, "player");
    local pX = floor(mp.x * 10000) / 100;
    local pY = floor(mp.y * 10000) / 100;
    
    local faction = UnitFactionGroup("player");
    local factionCode;
    if (faction == "Horde") then
        factionCode = 1;
    else
        factionCode = 2;
    end
    
    local minNode;  
    local minDistance;
    
    for key,node in pairs(nodes) do 
        
        local t={} ; i=1
        for str in string.gmatch(node.name, "([^,]+)") do
            t[i] = str
            i = i + 1
        end
        
        if (#t < 2) then  return "Not in questing zone" end
        
        local nodeZoneName = strsub(t[2], 2);        
        local mapInfo = C_Map.GetMapInfo(bestMap);
        
        if (factionCode == node.faction 
        and mapInfo.name == nodeZoneName) then
            
            local x = floor(node.position.x * 10000) / 100;
            local y = floor(node.position.y * 10000) / 100;
            
            local distance = ((pX - x)^2 + (pY - y)^2)^0.5;
            
            if (not minDistance or minDistance > distance) then
                minDistance = distance;
                minNode = node;
            end
        end
    end
    if (minNode) then 
        return minNode.name
    else 
        return "No flight point on this UIMap" 
    end
end

