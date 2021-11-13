fireBind = Input.Bind{
  Key = Keybinds.Fire1
}
altfireBind = Input.Bind{
  Key = Keybinds.Fire2
}

envLayerMask = Physics.CreateLayerMask("Environment")
outLayerMask = Physics.CreateLayerMask("Outdoors")
finalLayerMask = envLayerMask + outLayerMask

function OnEnable()
    ratStatue = transform.Find("ratStatue")
    ratTurret = transform.Find("ratTurret")
    normalSight = transform.Find("RAT/gun/Slide/FrontSight").gameObject.GetComponent("MeshRenderer")
    redSight = transform.Find("RAT/gun/Slide/FrontSightRed").gameObject.GetComponent("MeshRenderer")
    turretDelay = 10
    statueDelay = 15
    if Registry.Get("turretPlaceTime") == nil then 
        Registry.Set("turretPlaceTime", Time.time - turretDelay)
    end
    if Registry.Get("statuePlaceTime") == nil then
        Registry.Set("statuePlaceTime", Time.time - statueDelay)
    end
    if Registry.Get("turretCheck") == nil then
        Registry.Set("turretCheck", true)
    end
    if Registry.Get("statueCheck") == nil then
        Registry.Set("statueCheck", true)
    end
    turretTimer = Registry.Get("turretPlaceTime")
    statueTimer = Registry.Get("statuePlaceTime")
    NumberGrab()
    for i, num in ipairs(txt_num) do
        txt_num[i].enabled = false
    end
end

cooldownOff = false

function Update(deltatime)
  cooldownOff = CheatsManager.GetCheatState("ultrakill.no-weapon-cooldown")
  if fireBind.wasPressedThisFrame and turretReady then
    hitcastResult =
            Physics.Raycast(
            Player.head.position + Player.head.forward,
            Player.head.forward,
            Mathf.infinity,
            finalLayerMask
        )
    if hitcastResult ~= nil then
        if not cooldownOff then
            turretReady = false
            turretTimer = Time.time
        end
        turret = GameObject.Instantiate(ratTurret)
        turret.parent = nil
        turret.gameObject.layer = 24
        turret.transform.position = hitcastResult.point
        turret.transform.LookAt(Player.head)
        turret.transform.rotation = Quaternion.FromToRotation(turret.transform.up, hitcastResult.normal) * transform.rotation
        allChildren = turret.GetComponentsInChildren("Transform")
        for i,child in ipairs(allChildren) do
            child.gameObject.layer = 24
        end
        turret.gameObject.SetActive(true)
    end
  end
  if altfireBind.wasPressedThisFrame and statueReady then
    hitcastResult =
            Physics.Raycast(
            Player.head.position + Player.head.forward,
            Player.head.forward,
            Mathf.infinity,
            finalLayerMask
        )
    if hitcastResult ~= nil then
        if not cooldownOff then
            statueReady = false
            statueTimer = Time.time
            txt_ready.enabled = false
            txt_num[16].enabled = true
        end
        statue = GameObject.Instantiate(ratStatue)
        statue.parent = nil
        statue.gameObject.layer = 24
        statue.transform.position = hitcastResult.point
        statue.transform.LookAt(Player.head)
        statue.transform.rotation = Quaternion.FromToRotation(statue.transform.up, hitcastResult.normal) * transform.rotation
        allChildren = statue.GetComponentsInChildren("Transform")
        for i,child in ipairs(allChildren) do
            child.gameObject.layer = 24
        end
        statue.gameObject.SetActive(true)
        expP = AssetDatabase.Create("ExplosionPrime")
        expP.transform.position = hitcastResult.point
        expS = AssetDatabase.Create("ExplosionSuper")
        expS.transform.localScale = Vector3.__new(100, 100, 100)
        expS.transform.position = hitcastResult.point
        shock = AssetDatabase.Create("PhysicalShockwaveHarmless")
        shock.transform.position = hitcastResult.point

        __lastInstance = Registry.Get("lastStatue")
        if __lastInstance ~= nil then
            Object.Destroy(__lastInstance)
        end
        __lastInstance = statue.gameObject
        Registry.Set("lastStatue", __lastInstance)
    end
  end

  if not turretReady and Time.time - turretDelay >= turretTimer or cooldownOff then
    turretReady = true
  end
  if not statueReady and Time.time - statueDelay >= statueTimer or cooldownOff then
    statueReady = true
    for i, num in ipairs(txt_num) do
        txt_num[i].enabled = false
    end
  end

  if not statueReady then
    displayTime = Mathf.Ceil(statueDelay - (Time.time - statueTimer))
    for i, num in ipairs(txt_num) do
        txt_num[i].enabled = false
    end
    if displayTime ~= 0 then
        txt_num[displayTime+1].enabled = true
    else
        txt_ready.enabled = true
    end
  end

  if statueReady and not txt_ready.enabled then
    txt_ready.enabled = true
  end

  if not turretReady then
    normalSight.enabled = false
    redSight.enabled = true
  else
    redSight.enabled = false
    normalSight.enabled = true
  end
end

function NumberGrab()
    txt_ready = transform.Find("RAT/gun/Screen/TEXT/Ready").gameObject.GetComponent("MeshRenderer")
    txt_num = transform.Find("RAT/gun/Screen/TEXT/NUM").gameObject.GetComponentsInChildren("MeshRenderer")
end

function OnDisable()
    Registry.Set("turretPlaceTime", turretTimer)
    Registry.Set("statuePlaceTime", statueTimer)
end