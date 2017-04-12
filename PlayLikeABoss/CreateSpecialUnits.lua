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
	local unitType = Mod.Settings.SelectedUnitType; 
	local unit = unitTypes[unitType].Create(playerId)

	--local params = 
	--{
	--	["Power"] = 22,
	--	["Stage"] = 2
	--}
	
	-- not supported by Warlight
	--for key, value in pairs(unitParams) do
	--	unit[key] = value
	--end
	return unit

end
