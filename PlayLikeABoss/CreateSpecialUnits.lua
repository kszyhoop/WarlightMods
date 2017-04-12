function CreateSpecialUnits(game, standing)
	if game.Settings.LimitDistributionTerritories > 3 then
		print "allowed only with no more than 3 starts"
		return
	end

	for _, territory in pairs(standing.Territories) do
		if (not territory.IsNeutral) then
			local numArmies = territory.NumArmies.NumArmies
			local newArmies = WL.Armies.Create(numArmies, { CreateUnit(territory.OwnerPlayerID) }); 
			territory.NumArmies = newArmies
		end
	end
end

function CreateUnit(playerId)
	local unitTypes = 
	{
		[Mod.Settings.SpecialUnitTypeBoss1] = WL.Boss1,
		[Mod.Settings.SpecialUnitTypeBoss2] = WL.Boss2,
		[Mod.Settings.SpecialUnitTypeBoss3] = WL.Boss3,
		[Mod.Settings.SpecialUnitTypeBoss4] = WL.Boss4,
		[Mod.Settings.SpecialUnitTypeCommander] = WL.Commander
	}
	
	local specialUnitArgs = 
	{
		[Mod.Settings.SpecialUnitTypeBoss1] = nil,
		[Mod.Settings.SpecialUnitTypeBoss2] = nil,
		[Mod.Settings.SpecialUnitTypeBoss3] = {1},
		[Mod.Settings.SpecialUnitTypeBoss4] = nil,
		[Mod.Settings.SpecialUnitTypeCommander] = nil	
	}
	
	local unitType = Mod.Settings.SelectedUnitType; 
	local args = specialUnitArgs[unitType] 
	if (args ~= nil) then
		args = table.unpack(args)
	end
	local unit = unitTypes[unitType].Create(playerId, args)
	return unit
end
