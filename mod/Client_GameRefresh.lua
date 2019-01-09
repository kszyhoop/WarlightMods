function Client_GameRefresh(game)
	if game.Game.TurnNumber > 0 then return end; -- don't pop up in ongoing games, could be removed later

	if not Mod.PlayerGameData.InitialPopupDisplayed then
	--	UI.Alert("This game includes Swap Picks Mod - you pick for your opponent. Good luck :)")
	--	local payload = {};
	--	payload.Message = "InitialPopupDisplayed";
	--	game.SendGameCustomMessage("Please wait... ", payload, function(reply)end);
	end
end

