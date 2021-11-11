elements = {
	{"Water", {"Lightning"}, 0, "Spray", 1}, 
	{"Lightning", {"Water", "Earth"}, 1, "Spray", 2}, 
	{"Life", {"Arcane"}, 3, "Beam", 3},
	{"Arcane", {"Life"}, 3, "Beam", 4},
	{"Shield", {"Shield"}, 6, "Self", 5},
	{"Earth", {"Lightning"}, 5, "Projectile", 6},
	{"Cold", {"Fire"}, 0, "Spray", 7},
	{"Fire", {"Cold"}, 0, "Spray", 8},
	{"Steam", {"Cold"}, 2, "Spray", 9},
	{"Ice", {"Fire"}, 4, "Projectile", 10},
	{"Poison", {"Life"}, 2, "Spray", 11}
}

magicks = {
	{"Revive", {"Life", "Lightning"}},
	{"Grease", {"Water", "Earth", "Life"}},
	{"Haste", {"Lightning", "Arcane", "Fire"}},
	{"Invisibility", {"Arcane", "Shield", "Steam", "Arcane"}}
	{"Teleport", {"Lightning", "Arcane", "Lightning"}},
	{"Fear", {"Cold", "Arcane", "Shield"}},
	{"Charm", {"Life", "Shield", "Earth"}},
	{"Thunder Bolt", {"Steam", "Lightning", "Arcane", "Lightning"}},
	{"Rain", {"Water", "Steam"}},
	{"Tornado", {"Earth", "Steam", "Water", "Steam"}},
	{"Blizzard", {"Cold", "Ice", "Cold"}},
	{"Meteor Shower", {"Fire", "Earth", "Steam", "Earth", "Fire"}},
	{"Conflagration", {"Steam", "Fire", "Steam", "Fire", "Steam"}},
	{"Thunder Storm", {"Steam", "Steam", "Lightning", "Arcane", "Lightning"}},
	{"Time Warp", {"Cold", "Shield"}},
	{"Vortex", {"Ice", "Arcane", "Ice", "Shield", "Ice"}},
	{"Raise Dead", {"Ice", "Earth", "Arcane", "Cold"}},
	{"Summon Elemental", {"Arcane", "Shield", "Earth", "Steam", "Arcane"}},
	{"Summon Death", {"Arcane", "Cold", "Ice", "Cold", "Arcane"}},
	{"Summon Phoenix", {"Life", "Lightning", "Fire"}},
	{"Nullify", {"Arcane", "Shield"}},
	{"Corporealize", {"Arcane", "Steam", "Lightning", "Shield", "Arcane"}},
	{"Crash To Desktop", {"Lightning", "Lightning", "Fire", "Life"}},
	{"Napalm", {"Steam", "Earth", "Life", "Fire", "Fire"}},
	{"Portal", {"Steam", "Lightning", "Shield"}},
	{"Tractor Pull", {"Earth", "Arcane"}},
	{"Propp's Party Plasma", {"Fire", "Steam", "Arcane"}},
	{"Leviation", {"Steam", "Arcane", "Steam"}},
	{"Chain Lightning", {"Lightning", "Lightning", "Lightning"}},
	{"Confuse", {"Arcane", "Shield", "Lightning"}},
	{"The Wave", {"Earth", "Steam", "Earth", "Steam", "Earth"}},
	{"Performance Enhancement", {"Life", "Fire", "Lightning", "Fire", "Life"}},
	{"Spray of Judgement", {"Ice", "Ice", "Arcane", "Shield"}},
	{"Eruption", {"Fire", "Fire", "Fire", "Earth", "Shield"}},
	{"Almagameddon", {"Arcane", "Water", "Lightning"}}
}

leftClick = Input.Bind{
  Key = Keybinds.Fire1
}
rightClick = Input.Bind{
    Key = Keybinds.Fire2
}

playerList = nil

function OnEnable()
	if Registry.Get("playerMagic") == nil then
		Registry.Set("playerMagic", {})
	end
	playerList = Registry.Get("playerMagic")
	Registry.Set("magicka", nil)

	meshSpray = transform.Find("Spray")
	meshProjectile = transform.Find("Projectile")
	meshBeam = transform.Find("Beam")

	timeHeld = 0
	cast = false
end

function OnDisable()
	Registry.Set("playerMagic", playerList)
end

function Update()
	hold = false
	if leftClick.isHeld then
		cast = true
		hold = true
		timeHeld = timeHeld + Time.deltaTime
	end
	if not hold and cast then
		Cast(timeHeld)
	end
end

function Cast(castTime)
	priority = 0
	type = nil
	count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	for i, element in ipairs(playerList) do
		if element[3] > priority then
			priority = element[3]
			type = element[4]
		end
		count[element[5]] = count[element[5]] + 1
	end

end