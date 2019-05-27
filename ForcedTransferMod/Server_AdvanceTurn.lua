function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	if order.proxyType ~= 'GameOrderAttackTransfer' then return end;
	result.ActualArmies = order.NumArmies;
end
