function Server_Created(game, settings)
	if game.Settings.LimitDistributionTerritories > 3 then
		local modMessage = "PlayLikeABoss mod is enabled but not running. This mod can run only with no more than 3 starts per player."
		local currentMessage = settings.PersonalMessage
	
		if (currentMessage == nil) then 
			newMessage = modMessage 
		else
			newMessage = modMessage .. "\n" .. currentMessage
		end
		settings.PersonalMessage = newMessage
	end
end
