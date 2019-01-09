function Client_GameRefresh(game)
	if game.Game.TurnNumber > 0 then return end; -- don't pop up in ongoing games, could be removed later

	if not Mod.PlayerGameData.InitialPopupDisplayed then
	--	UI.Alert("This game includes Swap Picks Mod - you pick for your opponent. Good luck :)")
		local payload = {};
		payload.Message = "InitialPopupDisplayed";
		UI.Alert(game.SendGameCustomMessage);
		game.SendGameCustomMessage("Please wait... ", payload, callback);
	end
end

function callback(response)
	
end;

