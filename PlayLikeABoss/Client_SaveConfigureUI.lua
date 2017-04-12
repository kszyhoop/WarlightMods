
function Client_SaveConfigureUI(alert)
	for _, checkBox in pairs(unitTypeCheckBoxGroup) do
		if (checkBox.GetIsChecked()) then
			Mod.Settings.SelectedUnitType = checkBox.GetText()
		end
	end
end