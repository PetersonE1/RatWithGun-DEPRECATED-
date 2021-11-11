function OnEnable()
	time = Time.time
	timeToWait = Time.deltaTime * 3
end

spawned = false
counter = 0

function OnTriggerEnter(collider)
	if collider.gameObject.GetComponent("EnemyIdentifier") ~= nil and not spawned then
		collider.gameObject.GetComponent("EnemyIdentifier").Explode()
		counter = counter + 1
	end
end

function LateUpdate()
	if Time.time - timeToWait > time and not spawned then
		spawned = true
		if counter > 0 then
			if counter == 1 then
				Player.styleHUD.AddPoints(350, "<color=green>FRESHLY MURDERED</color>")
			else
				Player.styleHUD.AddPoints(350 * counter, "<color=green>FRESHLY MURDERED x" .. counter .. "</color>")
			end
		end
	end
end