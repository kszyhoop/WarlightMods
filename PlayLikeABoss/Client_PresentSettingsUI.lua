require("InitMod")

function Client_PresentSettingsUI(rootParent)
	InitializeIfNeeded()
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert).SetText('Selected special unit: ' .. Mod.Settings.SelectedUnitType);
end