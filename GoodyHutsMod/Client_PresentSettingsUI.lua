function Client_PresentSettingsUI(rootParent)
	UI.CreateLabel(rootParent).SetText('--- Main --- ');
	UI.CreateLabel(rootParent).SetText('Percent of territories with goody huts: ' .. Mod.Settings.GoodyHutsPercentage);
	local neutrals = Mod.Settings.GoodyHutsNeutrals;
	if neutrals == nil then neutrals = 'Unchanged' end;
	UI.CreateLabel(rootParent).SetText('Number of neutrals on goody huts: ' .. neutrals);
	UI.CreateLabel(rootParent).SetText('--- Events --- ');
	
	UI.CreateLabel(rootParent).SetText('Reinforce teritory event weight: ' .. Mod.Settings.Weights.ReinforceTerritory);
	UI.CreateLabel(rootParent).SetText('Reinforce territory multiplier: ' .. Mod.Settings.ReinforceTerritoryMultiplier);

	UI.CreateLabel(rootParent).SetText('Give territories event weight: ' .. Mod.Settings.Weights.GiveTerritories);

	UI.CreateLabel(rootParent).SetText('Disease event weight: ' .. Mod.Settings.Weights.Disease);
	UI.CreateLabel(rootParent).SetText('Disease strength: ' .. Mod.Settings.DiseaseStrength);
	UI.CreateLabel(rootParent).SetText('Disease range: ' .. Mod.Settings.DiseaseRange);

	UI.CreateLabel(rootParent).SetText('Natives gathering event weight: ' .. Mod.Settings.Weights.NativesGathering);
	
	UI.CreateLabel(rootParent).SetText('Unknown mushrooms event weight: ' .. Mod.Settings.Weights.UnknownMushrooms);
	
	UI.CreateLabel(rootParent).SetText('Zombie master event weight: ' .. Mod.Settings.Weights.ZombieMaster);
	UI.CreateLabel(rootParent).SetText('Zombie master atack count: ' .. Mod.Settings.ZombieMasterAttackCount);
	
	UI.CreateLabel(rootParent).SetText('Scared natives event weight: ' .. Mod.Settings.Weights.ScaredNatives);
	UI.CreateLabel(rootParent).SetText('Attacks with scared natives effect: ' .. Mod.Settings.ScaredNativesAttackCount);
	
end

