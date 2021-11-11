fireBind = Input.Bind{
  Key = Keybinds.Fire1
}
fireAltBind = Input.Bind{
    Key = Keybinds.Fire2
}

function OnEnable()
    origin = transform.Find("RAT/gun/MuzzleOrigin")
    if Registry.Get("ammoCounter") == nil then
        Registry.Set("ammoCounter", 7)
    end
    if Registry.Get("reloadTimer") == nil then
        Registry.Set("reloadTimer", 0)
    end
    if Registry.Get("reloadCheck") == nil then
        Registry.Set("reloadCheck", false)
    end
    ammo = Registry.Get("ammoCounter")
    reloadTime = Registry.Get("reloadTimer")
    reloading = Registry.Get("reloadCheck")
    NumberGrab()
    if not reloading then
        txt_num[ammo+1].enabled = true
    else
        txt_reloading.enabled = true
    end
end

cooldownOff = false

function Update(deltatime)
  cooldownOff = CheatsManager.GetCheatState("ultrakill.no-weapon-cooldown")
  if fireBind.wasPressedThisFrame and ammo > 0 and not reloading then
    txt_num[ammo+1].enabled = false
    if not cooldownOff then
        ammo = ammo - 1
    else
        ammo = 7
    end
    txt_num[ammo+1].enabled = true
    rb = AssetDatabase.Create("RevolverBeamAlt")
    rb.transform.position = origin.position
    rb.transform.rotation = Player.head.rotation
  elseif fireBind.wasPressedThisFrame and ammo == 0 and not reloading then
    reloading = true
    ReloadStart()
  end
  if fireAltBind.wasPressedThisFrame and ammo < 7  and not reloading then
    reloading = true
    ReloadStart()
  end
  if reloading then
    if reloadTime < 2.5 then
        reloadTime = reloadTime + Time.deltaTime
    else
        Reload()
    end
  end
end

function ReloadStart()
    txt_num[ammo+1].enabled = false
    txt_reloading.enabled = true
    reloadTime = 0
end

function Reload()
    reloading = false
    txt_reloading.enabled = false
    ammo = 7
    txt_num[ammo+1].enabled = true
end

function NumberGrab()
    txt_reloading = transform.Find("RAT/gun/Screen/TEXT/Reloading").gameObject.GetComponent("MeshRenderer")
    txt_num = transform.Find("RAT/gun/Screen/TEXT/NUM").gameObject.GetComponentsInChildren("MeshRenderer")
end

function OnDisable()
    Registry.Set("ammoCounter", ammo)
    Registry.Set("reloadTimer", reloadTime)
    Registry.Set("reloadCheck", reloading)
end