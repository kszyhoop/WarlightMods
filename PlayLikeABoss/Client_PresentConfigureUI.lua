require("InitMod")

function CheckboxOnValueChanged(sender, value)
	
	if value then    --- uncheck other checkboxes
		for  _, checkBox in pairs(checkBoxes) do
			if checkBox ~= sender and checkBox.GetIsChecked() then 
				checkBox.SetIsChecked(false)
			end
		end
	else 
		local isAnythingEnabled = false;
		for _, checkBox in pairs(checkBoxes) do
			isAnythingEnabled = isAnythingEnabled or checkBox.GetIsChecked()
 		end
		if not isAnythingEnabled then
			sender.SetIsChecked(true) -- sorry, i just can't let you do that :]
		end
	end
end


function Client_PresentConfigureUI(rootParent)
	print "PresentConfigureUI"
	InitializeIfNeeded()
	checkBoxes = { }
	local initialValue = Mod.Settings.SelectedUnitType
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local n = 0
	
	local specialUnitTypes = {	
			Mod.Settings.SpecialUnitTypeBoss1,
			Mod.Settings.SpecialUnitTypeBoss2,	
			Mod.Settings.SpecialUnitTypeBoss3,
			Mod.Settings.SpecialUnitTypeBoss4,
			Mod.Settings.SpecialUnitTypeCommander
		}
	
	print ("przed forem")
	for _, unitType in pairs(specialUnitTypes) do
		print ("robie fora")
		local cb = UI.CreateCheckBox(vert).SetText(unitType).SetIsChecked(initialValue == unitType)
		cb.SetOnValueChanged(
			function(value)
				CheckboxOnValueChanged(cb, value)
			end
		)
		checkBoxes[n] = cb
		n = n + 1
	end	
	print "po forze"
end

