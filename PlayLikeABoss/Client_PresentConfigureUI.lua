require("InitMod")

function CheckboxOnValueChanged(sender, value, checkBoxGroup)
	
	if value then    --- uncheck other checkboxes
		for  _, checkBox in pairs(checkBoxGroup) do
			if checkBox ~= sender and checkBox.GetIsChecked() then 
				checkBox.SetIsChecked(false)
			end
		end
	else 
		local isAnythingEnabled = false;
		for _, checkBox in pairs(checkBoxGroup) do
			isAnythingEnabled = isAnythingEnabled or checkBox.GetIsChecked()
 		end
		if not isAnythingEnabled then
			sender.SetIsChecked(true) -- sorry, i just can't let you do that :]
		end
	end
end


function Client_PresentConfigureUI(rootParent)
	InitializeIfNeeded()
	
	unitTypeCheckBoxGroup = { }
	local tableIndex = 0
	local specialUnitTypes = {	
			Mod.Settings.SpecialUnitTypeBoss1,
			Mod.Settings.SpecialUnitTypeBoss2,	
			Mod.Settings.SpecialUnitTypeBoss3,
			Mod.Settings.SpecialUnitTypeBoss4,
			Mod.Settings.SpecialUnitTypeCommander
		}

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert).SetText('Special unit type:');
	for _, unitType in pairs(specialUnitTypes) do
		local cb = UI.CreateCheckBox(vert).SetText(unitType).SetIsChecked(Mod.Settings.SelectedUnitType == unitType)
		cb.SetOnValueChanged(
			function(value)
				CheckboxOnValueChanged(cb, value, unitTypeCheckBoxGroup)
			end
		)
		unitTypeCheckBoxGroup[tableIndex] = cb
		tableIndex = tableIndex + 1
	end

end

