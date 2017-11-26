require('GoodyHuts')

function Server_StartGame(game, standing)
	if (game.Settings.AutomaticTerritoryDistribution) then
		PlaceGoodyHuts(game, standing);
	end
	for _, territory in pairs(standing.Territories) do
		if territory.Structures ~= nil and territory.Structures[WL.StructureType.City] > 0 then
			if not territory.IsNeutral then
				territory.Structures = { 0 };
			else 	
				territory.NumArmies = WL.Armies.Create(0);					
			end
		end
	end
	
end



