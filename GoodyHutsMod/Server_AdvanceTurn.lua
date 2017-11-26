require('GoodyHuts')

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	if order.proxyType == 'GameOrderAttackTransfer' then
		if MushroomsEffectEnabled then 
			result.ActualArmies = WL.Armies.Create(game.ServerGame.LatestTurnStanding.Territories[order.From].NumArmies.NumArmies)
			if (result.IsAttack) then	
				result.DefendingArmiesKilled = WL.Armies.Create(math.min(result.ActualArmies.AttackPower, game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.NumArmies));
				result.IsSuccessful = result.DefendingArmiesKilled.NumArmies == game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.NumArmies
			else 
				-- to avoid "can't transfer" bug
				if order.PlayerID == game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID then
					result.IsSuccessful = true;
				end
			end
		end
		
		territory = game.ServerGame.LatestTurnStanding.Territories[order.To];
		if territory.IsNeutral and territory.Structures ~= nil and territory.Structures[WL.StructureType.City] > 0 and result.IsAttack and result.IsSuccessful then 
			local mod = WL.TerritoryModification.Create(order.To);
			mod.SetStructuresOpt = { 0 }
			if MushroomsEffectEnabled or game.ServerGame.Game.Players[order.PlayerID].IsAI then
				addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "Goody hut has been destroyed", {}, {mod}));
			else
				addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "You have captured goody hut", {}, {mod}));
				ChooseAndApplyEffect(game, order, result, addNewOrder)
			end
		end
		
		ApplyZombieMasterEffect(game, order, result, addNewOrder)
		ApplyScaredNativesEffect(game, order, result, skipThisOrder, addNewOrder)
	end
	if MushroomsEffectEnabled and order.proxyType == 'GameOrderCustom' then 
		if order.Payload == 'MUSHROOM_EFFECT_OFF' then
			MushroomsEffectEnabled = false;
		end
	end
end

