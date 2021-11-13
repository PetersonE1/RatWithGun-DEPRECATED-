function OnEnable()
	timeToWait = Time.deltaTime * 3
	Invoke(KillCheck, timeToWait)
end

enabled = true
counter = 0

function OnTriggerEnter(collider)
	if enabled and collider.gameObject.GetComponent("EnemyIdentifier") ~= nil then
		collider.gameObject.GetComponent("EnemyIdentifier").Explode()
		counter = counter + 1
	end
end

function KillCheck()
	enabled = false
	if counter > 0 then
		if counter == 1 then
			Player.styleHUD.AddPoints(350, "<color=green>FRESHLY MURDERED</color>")
		else
			Player.styleHUD.AddPoints(350 * counter, "<color=green>FRESHLY MURDERED x" .. counter .. "</color>")
		end
	end
end