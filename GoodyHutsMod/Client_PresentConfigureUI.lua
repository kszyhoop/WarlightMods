function Client_PresentConfigureUI(rootParent)
	-- density and neutrals
	local goodyHutsPercentage = Mod.Settings.GoodyHutsPercentage;
	if goodyHutsPercentage == nil then goodyHutsPercentage = 10; end
	local goodyHutsNeutrals = Mod.Settings.GoodyHutsNeutrals;
	if goodyHutsNeutrals == nil then goodyHutsNeutrals = 0; end
	-- reinforce territory: 
	if Mod.Settings.Weights == nil then Mod.Settings.Weights = {}; end;
	local reinforceTerritoryWeight = Mod.Settings.Weights.ReinforceTerritory;
	if reinforceTerritoryWeight == nil then reinforceTerritoryWeight = 1; end
	local reinforceTerritoryMultiplier = Mod.Settings.ReinforceTerritoryMultiplier;
	if reinforceTerritoryMultiplier == nil then reinforceTerritoryMultiplier = 2; end	
    -- give territories
	local giveTerritoriesWeight = Mod.Settings.Weights.GiveTerritories;
	if giveTerritoriesWeight == nil then giveTerritoriesWeight = 1; end
    -- disease
	local diseaseWeight = Mod.Settings.Weights.Disease;
	if diseaseWeight == nil then diseaseWeight = 1; end
	local diseaseStrength = Mod.Settings.DiseaseStrength;
	if diseaseStrength == nil then diseaseStrength = 0.5; end
	local diseaseRange = Mod.Settings.DiseaseRange;
	if diseaseRange == nil then diseaseRange = 5; end
    -- native gathering
	local nativesGatheringWeight = Mod.Settings.Weights.NativesGathering;
	if nativesGatheringWeight == nil then nativesGatheringWeight = 1; end
	-- insanity
	local unknownMushroomsWeight = Mod.Settings.Weights.UnknownMushrooms;
	if unknownMushroomsWeight == nil then unknownMushroomsWeight = 1; end
    -- zombie maaster
	local zombieMasterWeight = Mod.Settings.Weights.ZombieMaster;
	if zombieMasterWeight == nil then zombieMasterWeight = 1; end
	local zombieMasterAttackCount = Mod.Settings.ZombieMasterAttackCount;
	if zombieMasterAttackCount == nil then zombieMasterAttackCount = 3; end	
	-- scared natives
	local scaredNativesWeight = Mod.Settings.Weights.ScaredNatives;
	if scaredNativesWeight == nil then scaredNativesWeight = 1; end	
	local scaredNativesAttackCount = Mod.Settings.ScaredNativesAttackCount;
	if scaredNativesAttackCount == nil then scaredNativesAttackCount = 5; end	
	
	
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Percent of territories with goody huts');
	goodyHutPercentageNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(50).SetValue(goodyHutsPercentage);	
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Number of neutrals on goody huts');
	goodyHutNeutralsNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(20).SetValue(goodyHutsNeutrals);	
	-- reinforce
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Reinforce territory event weight');
	reinforceTerritoryNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(reinforceTerritoryWeight);
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Reinforce territory multiplier');
    reinforceTerritoryMultiplierNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(1).SetSliderMaxValue(5).SetValue(reinforceTerritoryMultiplier).SetWholeNumbers(false);
	-- give territory
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Give territory event weight')
	giveTerritoriesNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(giveTerritoriesWeight);
	-- disease
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Disease event weight')
	diseaseNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(diseaseWeight);
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Disease strength')
	diseaseStrengthNIF = UI.CreateNumberInputField(horz).SetWholeNumbers(false).SetSliderMinValue(0).SetSliderMaxValue(1).SetValue(diseaseStrength);
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Disease range')
	diseaseRangeNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(1).SetSliderMaxValue(10).SetValue(diseaseRange);
	-- native gathering
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Natives gathering event weight')
	nativesGatheringNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(nativesGatheringWeight);
	-- unknown mushrooms
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Unknown mushrooms event weight')
	unknownMushroomsNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(unknownMushroomsWeight);
	-- zombie master
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Zombie master event weight')
	zombieMasterNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(zombieMasterWeight);
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Zombie master attack count')
	zombieMasterAttackCountNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(1).SetSliderMaxValue(10).SetValue(zombieMasterAttackCount);
	--  fear of natives
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Scared natives event weight')
	scaredNativesNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(10).SetValue(scaredNativesWeight);
    local horz = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz).SetText('Attacks with scared natives effect')
	scaredNativesAttackCountNIF = UI.CreateNumberInputField(horz).SetSliderMinValue(0).SetSliderMaxValue(30).SetValue(scaredNativesAttackCount);

end