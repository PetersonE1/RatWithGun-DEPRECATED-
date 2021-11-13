enabled = true
checking = false
enemyAlive = {}
counter = 0

function OnEnable()
	gameObject.layer = 8
	Invoke(Disable, Time.deltaTime * 3)
	Invoke(Destroy, 2)
end

function OnTriggerEnter(collider)
	if enabled and collider.gameObject.GetComponent("EnemyIdentifier") ~= nil then
		table.insert(enemyAlive, collider.gameObject.GetComponent("EnemyIdentifier"))
	end
end

function Disable()
	enabled = false
end

function Destroy()
	Object.Destroy(gameObject)
end

function Update()
	if not checking then
		checking = true
		for i, enemy in ipairs(enemyAlive) do
			if enemy.dead then
				table.remove(enemyAlive, i)
				Player.styleHUD.AddPoints(45, "EXPLODED")
				counter = counter + 1
				if counter == 2 then
					Player.styleHUD.AddPoints(25, "<color=orange>DOUBLE KILL</color>")
				end
				if counter == 3 then
					Player.styleHUD.AddPoints(50, "<color=orange>TRIPLE KILL</color>")
				end
				if counter > 3 then
					Player.styleHUD.AddPoints(100, "<color=orange>MULTIKILL x" .. counter .. "</color>")
				end
			end
		end
		checking = false
	end
end