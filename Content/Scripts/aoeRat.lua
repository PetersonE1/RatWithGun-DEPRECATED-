fireBind = Input.Bind{
  Key = Keybinds.Fire1
}
fireAltBind = Input.Bind{
    Key = Keybinds.Fire2
}

function OnEnable()
    origin = transform.Find("RAT/gun/MuzzleOrigin")
    projectile = transform.Find("Projectile").gameObject
    cooldownOff = false
    readyToFire = true
end

function Update(deltatime)
  cooldownOff = CheatsManager.GetCheatState("ultrakill.no-weapon-cooldown")
  if fireBind.wasPressedThisFrame and (readyToFire or cooldownOff) then
    readyToFire = false
    Invoke(Ready, 1.5)
    proj = GameObject.Instantiate(projectile)
    proj.transform.parent = nil
    proj.layer = 14
    proj.transform.position = origin.position
    proj.transform.rotation = Player.head.rotation
    proj.AddFloatingPointErrorPreventer()
    proj.SetActive(true)
  end
end

function Ready()
    readyToFire = true
end