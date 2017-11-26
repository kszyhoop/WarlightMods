function ChooseAndApplyEffect(game, order, result, addNewOrder)
	local selected = SelectEffect();
	print(selected)
	if (selected == "ReinforceTerritory") then
		ReinforceTerritory(game, order, result, addNewOrder) 
	elseif (selected == "GiveTerritories") then
		GiveSurroundingTerritories(game, order, result, addNewOrder) 
	elseif (selected == "Disease") then
		Disease(game, order, result, addNewOrder) 
	elseif (selected == "NativesGathering") then
		NativesGathering(game, order, result, addNewOrder) 
	elseif (selected == "UnknownMushrooms") then
		UnknownMushrooms(game, order, result, addNewOrder) 
	elseif (selected == "ZombieMaster") then
		ZombieMaster(game, order, result, addNewOrder) 
	elseif (selected == "ScaredNatives") then
		ScaredNatives(game, order, result, addNewOrder)
	end
end

function ReinforceTerritory(game, order, result, addNewOrder)
	local mod = WL.TerritoryModification.Create(order.To);
	mod.SetArmiesTo = (result.ActualArmies.NumArmies - result.AttackingArmiesKilled.NumArmies) * Mod.Settings.ReinforceTerritoryMultiplier;
	local diff = mod.SetArmiesTo - (result.ActualArmies.NumArmies - result.AttackingArmiesKilled.NumArmies);
	local territoryName = game.Map.Territories[order.To].Name;
	local message = diff .. " friendly natives joined your forces in " .. territoryName;
	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message, {}, {mod}));
end

-- TODO: mo¿e zostawiæ neutralsy albo daæ zero
function GiveSurroundingTerritories(game, order, result, addNewOrder)
	local mapTerritory = game.Map.Territories[order.To]
	for _, neighbour in pairs(mapTerritory.ConnectedTo) do
		neighbourStanding = game.ServerGame.LatestTurnStanding.Territories[neighbour.ID] 
		if (neighbourStanding.IsNeutral and neighbourStanding.Structures == nil) then 
			local mod = WL.TerritoryModification.Create(neighbour.ID);
			mod.SetArmiesTo = 1;
			mod.SetOwnerOpt = order.PlayerID
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "Natives from area surrounding " .. mapTerritory.Name .. " pledged loyalty to you", {}, {mod}));	
		end
	end
end

-- TODO: mo¿e chorowaæ powinien nie tylko zajmuj¹cy ale wszyscy
function Disease(game, order, result, addNewOrder) 
	local maxDistance = Mod.Settings.DiseaseRange
	local maxStrength = Mod.Settings.DiseaseStrength
	local sourceTerritory = game.ServerGame.LatestTurnStanding.Territories[order.To];
	local diseaseSourceName = game.Map.Territories[order.To].Name;
	local neighbourhood = FindNeighbourhood(game, sourceTerritory, maxDistance, order.PlayerID);
	for distance, territoryIDs in pairs(neighbourhood) do
		local deathRate =  (1 - (distance / (maxDistance + 1))) * maxStrength
		for _, territoryID  in ipairs(territoryIDs) do 
			local territory = game.ServerGame.LatestTurnStanding.Territories[territoryID];
			local mod = WL.TerritoryModification.Create(territoryID)
			local previous = territory.NumArmies.NumArmies;
			-- LatestTurnStanding doesn't know about armies in conquered territory and armies sent from original territory
			if (territoryID == order.To)  then previous = (result.ActualArmies.NumArmies - result.AttackingArmiesKilled.NumArmies) end;
			if (territoryID == order.From) then previous = previous - result.ActualArmies.NumArmies; end
			local killedTroops = math.floor((deathRate * previous) + 0.5, 0);
			mod.SetArmiesTo = previous - killedTroops;
			local territoryName = game.Map.Territories[territoryID].Name;
			if (killedTroops > 0) then
				local message = "Disease spreaded from " .. diseaseSourceName .. " killed " .. killedTroops .. " troops in " .. territoryName;
				addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod}));	
			end
		end
	end
end

function NativesGathering(game, order, result, addNewOrder) 
	local farNativesArmyCount = 0;
	local nearNativesTerritoryCount = 0;
	local territory = game.ServerGame.LatestTurnStanding.Territories[order.To];
	local distances = FindNeighbourhood(game, territory, 2, WL.PlayerID.Neutral);
	if (#(distances[1]) > 0 and #(distances[2]) > 0) then
		for _, id in ipairs(distances[2]) do
			local mod = WL.TerritoryModification.Create(id);
			mod.SetArmiesTo = 0;
			local territory = game.ServerGame.LatestTurnStanding.Territories[id];
			local territoryName = game.Map.Territories[id].Name;
			local message = "Natives from " .. territoryName .. " left their settlements"; 
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {order.PlayerID}, {mod}));	
			farNativesArmyCount = farNativesArmyCount + territory.NumArmies.NumArmies;
		end
		local nearNativesTerritoryCount = #(distances[1])
		local armyPerTerritory = math.floor(farNativesArmyCount / nearNativesTerritoryCount)
		local rest = farNativesArmyCount - (armyPerTerritory * nearNativesTerritoryCount)
		for _, id in ipairs(distances[1]) do
			territory = game.ServerGame.LatestTurnStanding.Territories[id];
			local mod = WL.TerritoryModification.Create(id);
			mod.SetArmiesTo = territory.NumArmies.NumArmies + (farNativesArmyCount / nearNativesTerritoryCount);
			if (rest > 0) then
				mod.SetArmiesTo = mod.SetArmiesTo + 1;
				rest = rest - 1;
			end
			local diff = mod.SetArmiesTo - territory.NumArmies.NumArmies;
			local territoryName = game.Map.Territories[id].Name;
			local message = diff .. " natives arrive to " .. territoryName .. " to help their brothers defend their homes"; 
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod}));	
		end
	else
		addNewOrder(WL.GameOrderCustom.Create(order.PlayerID, "Natives glowered at your armies suspiciously, but nothing beside that", ""))
	end
end


function ScaredNatives(game, order, result, addNewOrder) 
	local playerGameData = Mod.PlayerGameData;
	local currentPlayerData = playerGameData[order.PlayerID]
	if currentPlayerData == nil then currentPlayerData = {} end
	local  scaredNativesPlayerData = currentPlayerData.ScaredNativesPlayerData;
	if scaredNativesPlayerData == nil then scaredNativesPlayerData = { }; end;
	scaredNativesPlayerData[game.ServerGame.Game.TurnNumber + 1] = Mod.Settings.ScaredNativesAttackCount;
	currentPlayerData.ScaredNativesPlayerData = scaredNativesPlayerData
	playerGameData[order.PlayerID] = currentPlayerData;
	Mod.PlayerGameData = playerGameData;	
	addNewOrder(WL.GameOrderCustom.Create(order.PlayerID, "Rumors about your might armies are spread amongst natives. They will flee from your " .. Mod.Settings.ScaredNativesAttackCount .. " first attacks next turn", ""))
	
end

function ApplyScaredNativesEffect(game, order, result, skipThisOrder, addNewOrder)
	if not result.IsAttack then return end;
	local territory = game.ServerGame.LatestTurnStanding.Territories[order.To]
	if not territory.IsNeutral then return end;
	if territory.NumArmies.NumArmies == 0 then return end;
	if Mod.PlayerGameData[order.PlayerID] == nil then return end
	local scaredNativesPlayerData = Mod.PlayerGameData[order.PlayerID].ScaredNativesPlayerData;
	if scaredNativesPlayerData == nil then return end
	local currentTurnData = scaredNativesPlayerData[game.ServerGame.Game.TurnNumber]
	if currentTurnData == nil then return end;
	if currentTurnData > 0 then
		local nativesToSpread = game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.NumArmies;
		local distances = FindNeighbourhood(game, territory, 1, WL.PlayerID.Neutral);
		if (distances[1] ~= nil and #distances[1] > 0) then 
			local mod = WL.TerritoryModification.Create(order.To);
			mod.SetArmiesTo = 0
			local territoryName = game.Map.Territories[order.To].Name;
			local message = territory.NumArmies.NumArmies .. " natives from " .. territoryName .. " fled before your armies";
			local move = WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod});	
			addNewOrder(move)
			local armyPerTerritory = math.floor(nativesToSpread / #(distances[1]))
			local rest = nativesToSpread - (armyPerTerritory * #(distances[1]));
			for _, id in ipairs(distances[1]) do
				local territory = game.ServerGame.LatestTurnStanding.Territories[id];
				local mod = WL.TerritoryModification.Create(id);
				mod.SetArmiesTo = territory.NumArmies.NumArmies + armyPerTerritory;
				if (rest > 0) then 
					mod.SetArmiesTo = mod.SetArmiesTo + 1;
					rest = rest - 1;
				end
				local diff = mod.SetArmiesTo - territory.NumArmies.NumArmies;
				if diff > 0 then
					local territoryName = game.Map.Territories[id].Name;
					local message = diff .. " fleeing natives has settled in " .. territoryName;
					addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod}));	
				end
			end
		else
			local mod = WL.TerritoryModification.Create(order.To);
			mod.SetArmiesTo = 0
			local territoryName = game.Map.Territories[order.To].Name;
			local message = nativesToSpread .. " natives from " .. territoryName .. " prefered to commit suicide than fight your almighty forces"
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod}));	
		end
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
		addNewOrder(order);
		currentTurnData = currentTurnData - 1;
		if (currentTurnData == 0) then currentTurnData = nil; end;
		scaredNativesPlayerData[game.ServerGame.Game.TurnNumber] = currentTurnData;
		Mod.PlayerGameData[order.PlayerID].ScaredNativesPlayerData = scaredNativesPlayerData;
	end
end

function UnknownMushrooms(game, order, result, addNewOrder) 
	local transferPercentage = 0.1;
	local minUnits = 1;
	if not game.ServerGame.Settings.OneArmyStandsGuard then minUnits = 0; end
	local territoryWithMovableUnits = {};
	local totalTerritoriesCount = 0;
	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if territory.OwnerPlayerID == order.PlayerID then
			totalTerritoriesCount = totalTerritoriesCount + 1;
			if territory.NumArmies.NumArmies > minUnits then
				table.insert(territoryWithMovableUnits, territory)
			end
		end
	end
	local affectedTerritories = math.floor(0.5 + transferPercentage * totalTerritoriesCount);
	if (affectedTerritories < 2) then affectedTerritories = 2 end;
	if (affectedTerritories > #territoryWithMovableUnits) then affectedTerritories = #territoryWithMovableUnits end
	
	addNewOrder(WL.GameOrderCustom.Create(order.PlayerID, "Mushrooms you bought from natives and sent to markets across your country appears to be psychedelic. Your people are out of control", ""))
	for i = 1, affectedTerritories do
		local rand = math.random(i, #territoryWithMovableUnits)
		local territory = territoryWithMovableUnits[rand]
		local mapTerritory = game.Map.Territories[territory.ID];
		local neighboursIDs = { };
		for key, _ in pairs(mapTerritory.ConnectedTo) do 
			table.insert(neighboursIDs,key);
		end
		local neighbourID = neighboursIDs[math.random(1, #neighboursIDs)];
		local attackOrder = WL.GameOrderAttackTransfer.Create(order.PlayerID, territory.ID, neighbourID, 3, true, WL.Armies.Create(100), true) 
		addNewOrder(attackOrder);
		territoryWithMovableUnits[i], territoryWithMovableUnits[rand] = territoryWithMovableUnits[rand], territoryWithMovableUnits[i]
	end
	addNewOrder(WL.GameOrderCustom.Create(order.PlayerID, "Looks like everything is back into normal. Maybe just beside strong headache", "MUSHROOM_EFFECT_OFF"))
	MushroomsEffectEnabled = true;
end

function ZombieMaster(game, order, result, addNewOrder) 
	local playerGameData = Mod.PlayerGameData;
	local currentPlayerData = playerGameData[order.PlayerID]
	if currentPlayerData == nil then currentPlayerData = {} end
	local zombieMasterPlayerData = currentPlayerData.ZombieMasterPlayerData;
	if zombieMasterPlayerData == nil then zombieMasterPlayerData = { }; end;
	zombieMasterPlayerData[game.ServerGame.Game.TurnNumber + 1] = Mod.Settings.ZombieMasterAttackCount;
	currentPlayerData.ZombieMasterPlayerData = zombieMasterPlayerData
	playerGameData[order.PlayerID] = currentPlayerData;
	Mod.PlayerGameData = playerGameData;	
	addNewOrder(WL.GameOrderCustom.Create(order.PlayerID, "You have met local zombie ressurector. He offered you to help and next turn he will turn soldiers defeated in your " .. Mod.Settings.ZombieMasterAttackCount .. " first attacks into zombie fighting for you", ""))
end

function ApplyZombieMasterEffect(game, order, result, addNewOrder)
	if not result.IsAttack then return end;
	if Mod.PlayerGameData[order.PlayerID] == nil then return end
	local zombieMasterPlayerData = Mod.PlayerGameData[order.PlayerID].ZombieMasterPlayerData;
	if zombieMasterPlayerData == nil then return end
	local currentTurnData = zombieMasterPlayerData[game.ServerGame.Game.TurnNumber]
	if currentTurnData == nil then return end;
	if currentTurnData > 0 then
		local defendingArmiesKilled = result.DefendingArmiesKilled.NumArmies
		if (defendingArmiesKilled > 0) then
			local territoryApplyTo = nil;
			if result.IsSuccessful then territoryApplyTo = order.To else territoryApplyTo = order.From end
			local originalArmies = 0;
			if result.IsSuccessful then 
				originalArmies = result.ActualArmies.NumArmies - result.AttackingArmiesKilled.NumArmies
			else
				originalArmies = game.ServerGame.LatestTurnStanding.Territories[order.From].NumArmies.NumArmies - result.AttackingArmiesKilled.NumArmies;
			end;
			local mod = WL.TerritoryModification.Create(territoryApplyTo)
			mod.SetArmiesTo = originalArmies + defendingArmiesKilled
			local territoryName = game.Map.Territories[territoryApplyTo].Name;
			local message = "Zombie ressurector with your army in " .. territoryName .." created " .. defendingArmiesKilled .. " zombies from enemy soldier fallen in battle. Now they will serve you"
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, message , {}, {mod}));	
		end
		currentTurnData = currentTurnData - 1;
		print(currentTurnData)
		if (currentTurnData == 0) then currentTurnData = nil; end;
		zombieMasterPlayerData[game.ServerGame.Game.TurnNumber] = currentTurnData;
		local currentPlayerGameData = Mod.PlayerGameData[order.PlayerID];
		currentPlayerGameData.ZombieMasterPlayerData = zombieMasterPlayerData;
		local playerGameData = Mod.PlayerGameData;
		playerGameData[order.PlayerID] = currentPlayerGameData;
		Mod.PlayerGameData = playerGameData;
	end
end

-- BFS or at least i hope so
function FindNeighbourhood (game, sourceTerritory, maxDistance, playerID)
	local result = {}
	local visited = {}
	local map = game.Map;
	local territoryStanding = game.ServerGame.LatestTurnStanding.Territories;
	-- sourceTerritoryId as starting point with distance = 0;
	result[0] = {sourceTerritory.ID}
	visited[sourceTerritory.ID] = true;
	local distance = 0
	while distance < maxDistance do
		result[distance + 1] = {}
		for i, territoryID in ipairs(result[distance]) do
			local mapTerritory = map.Territories[territoryID]
			-- check connection and visit territory not yet visited (optionally use only player territories)
			for _, neighbour in pairs(mapTerritory.ConnectedTo) do
				if (not visited[neighbour.ID] and(playerID == nil or territoryStanding[neighbour.ID].OwnerPlayerID == playerID)) then
					table.insert(result[distance + 1], neighbour.ID)
					visited[neighbour.ID] = true
				end
			end
		end
		distance = distance + 1;
	end
	return result;
end

function SelectEffect()
	local totalWeight = 0
	local weightToEffectMap = {}
	
	for effect, weight in pairs(Mod.Settings.Weights) do
		if weight > 0 then
			weightToEffectMap[totalWeight] = effect;
			totalWeight = totalWeight + weight;
		end
	end
	print ('total weight', totalWeight - 1);
	for k, v in  pairsByKeysReversed(weightToEffectMap) do
		print (k .. "->" .. v)
	end
	local rand= math.random(0, totalWeight - 1)
	for key, value in pairsByKeysReversed(weightToEffectMap) do
		if rand >= key then return value; end;
	end
end

function PlaceGoodyHuts(game, standing)
	local territoryIDs = { }
	local totalTerritories = 0;
	for tID, territory in pairs(standing.Territories) do
		totalTerritories = totalTerritories + 1;
		territoryIDs[totalTerritories] = tID;
	end
	local totalGoodyHuts = (Mod.Settings.GoodyHutsPercentage / 100)* totalTerritories;
		for i = 1, totalGoodyHuts do 
		local rnd = math.random (i, totalTerritories)
		local territory = standing.Territories[territoryIDs[rnd]]
		territory.Structures = { 1 };
		territoryIDs[i], territoryIDs[rnd] = territoryIDs[rnd], territoryIDs[i] 
	end
end

function pairsByKeysReversed (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a,  function(x, y) return x > y end)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
end