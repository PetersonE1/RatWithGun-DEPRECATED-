spawned = false
enemyList = nil
envLayerMask = Physics.CreateLayerMask("Environment")
outLayerMask = Physics.CreateLayerMask("Outdoors")
enemyLayerMask = Physics.CreateLayerMask("EnemyTrigger")
bigCorpseLayerMask = Physics.CreateLayerMask("BigCorpse")
finalLayerMask = envLayerMask + outLayerMask + enemyLayerMask + bigCorpseLayerMask

function OnEnable()
	timeStart = Time.time
	timeToWait = 10
	fireDelay = 0.5
	lastFired = Time.time

	Invoke(StartGun, 0.5)

	gun = transform.Find("RAT/GUN")
	muzzleOrigin = transform.Find("RAT/GUN/BARREL/MuzzleOrigin")
	cooldownOff = CheatsManager.GetCheatState("ultrakill.no-weapon-cooldown")
end

function Update()
	if spawned and (Time.time - fireDelay >= lastFired or cooldownOff) then
		enemyList = GameObject.FindGameObjectsWithTag("Enemy")
		distance = Mathf.infinity
		index = 1
		weakZone = nil
		for i, enemyCheck in ipairs(enemyList) do
			if enemyCheck.GetComponentInChildren("EnemyIdentifier") ~= nil and not enemyCheck.GetComponentInChildren("EnemyIdentifier").dead then
				weakZone = enemyCheck.GetComponentInChildren("EnemyIdentifier").weakPoint
				if weakZone ~= nil then
					direction = (weakZone.transform.position - gun.position).normalized
				else
					direction = (enemyCheck.transform.position - gun.position).normalized
				end
				hitcastResult =
						Physics.Raycast(
						gun.position,
						direction,
						Mathf.infinity,
						finalLayerMask
					)
				tempDist = Vector3.Distance(enemyCheck.transform.position, transform.position)
				if tempDist < distance and hitcastResult ~= nil and (hitcastResult.gameObject.GetComponentInChildren("EnemyIdentifier") ~= nil or hitcastResult.gameObject.GetComponentInChildren("EnemyIdentifierIdentifier") ~= nil) then
					distance = tempDist
					index = i
					weakPoint = weakZone
					aimDirection = direction
				end
			end
		end
		if enemyList[index] ~= nil and enemyList[index].GetComponentInChildren("EnemyIdentifier") ~= nil and not enemyList[index].GetComponentInChildren("EnemyIdentifier").dead and aimDirection ~= nil then
			chosenEnemy = enemyList[index]
			enemy = chosenEnemy.GetComponentInChildren("EnemyIdentifier")
			lookRotation = Quaternion.LookRotation(aimDirection)
			gun.rotation = lookRotation
			hitcastResult =
					Physics.Raycast(
					gun.position,
					aimDirection,
					Mathf.infinity,
					finalLayerMask
				)
			if hitcastResult ~= nil and (hitcastResult.gameObject.GetComponentInChildren("EnemyIdentifier") ~= nil or hitcastResult.gameObject.GetComponentInChildren("EnemyIdentifierIdentifier") ~= nil) then
				bullet = AssetDatabase.Create("RevolverBeamAlt")
				bullet.transform.position = muzzleOrigin.position
				bullet.transform.rotation = gun.rotation
				lastFired = Time.time
			end
		end
	end
end

function LateUpdate()
	if Time.time - timeToWait > timeStart then
		Destroy(gameObject)
	end
end

function StartGun()
	spawned = true
end