
specialUnitTypes = { }
function InitializeIfNeeded()
	if Mod.Settings.Initialized == nil then
		Mod.Settings.SpecialUnitTypeBoss1 = "Boss1"
		Mod.Settings.SpecialUnitTypeBoss2 = "Boss2"
		Mod.Settings.SpecialUnitTypeBoss3 = "Boss3"
		Mod.Settings.SpecialUnitTypeBoss4 = "Boss4"
		Mod.Settings.SpecialUnitTypeCommander = "Commander"
		
		specialUnitTypes = {	
			Mod.Settings.SpecialUnitTypeBoss1,
			Mod.Settings.SpecialUnitTypeBoss2,	
			Mod.Settings.SpecialUnitTypeBoss3,
			Mod.Settings.SpecialUnitTypeBoss4,
			Mod.Settings.SpecialUnitTypeCommander
		}

		Mod.Settings.SelectedUnitType = Mod.Settings.SpecialUnitTypeCommander
		Mod.Settings.Initialized = true
	end
end

