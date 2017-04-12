
function Client_SaveConfigureUI(alert)
	for _, checkBox in pairs(checkBoxes) do
		if (checkBox.GetIsChecked) then
			Mod.Settings.SelectedUnitType = checkBox.GetText()
		end
	end
end