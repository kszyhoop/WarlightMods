function Client_SaveConfigureUI(alert)  
	Mod.Settings.Weights.ReinforceTerritory = reinforceTerritoryNIF.GetValue();
	Mod.Settings.ReinforceTerritoryMultiplier = reinforceTerritoryMultiplierNIF.GetValue();
	Mod.Settings.Weights.GiveTerritories = giveTerritoriesNIF.GetValue();
	Mod.Settings.Weights.Disease = diseaseNIF.GetValue();
	Mod.Settings.DiseaseStrength = diseaseStrengthNIF.GetValue();
	Mod.Settings.DiseaseRange = diseaseRangeNIF.GetValue();
	Mod.Settings.Weights.NativesGathering = nativesGatheringNIF.GetValue();
	Mod.Settings.Weights.UnknownMushrooms = unknownMushroomsNIF.GetValue();
	Mod.Settings.Weights.ZombieMaster = zombieMasterNIF.GetValue();
	Mod.Settings.ZombieMasterAttackCount = zombieMasterAttackCountNIF.GetValue();
	Mod.Settings.Weights.ScaredNatives = scaredNativesNIF.GetValue();
	Mod.Settings.ScaredNativesAttackCount = scaredNativesAttackCountNIF.GetValue();
	Mod.Settings.GoodyHutsPercentage = goodyHutPercentageNIF.GetValue();
	Mod.Settings.GoodyHutsNeutrals = goodyHutNeutralsNIF.GetValue();
end