require('GoodyHuts')

function Server_StartDistribution(game, standing)
	if (not game.Settings.AutomaticTerritoryDistribution) then
		PlaceGoodyHuts(game, standing);
	end
end



