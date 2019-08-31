--Transform v0.1
local transform = {}

function transform.new(newX, newY, rotation, scale)
	
	local newT = {}
	
	newT.position = { x = newX, y = newY }	
	newT.rotation = rotation or 0
	newT.scale = scale or 1
	
	function newT.Translate(newx, newy)
		
		if type(newx) ~= 'number' then -- Not a Number
			if type(newx) == 'table' and newx.x == nil then -- Table
				newy = newx[2]
				newx = newx[1]
			elseif newx.x ~= nil then --Vector
				newy = newx.y
				newx = newx.x
			end
		end
		
		newT.position.x = newT.position.x + newx
		newT.position.y = newT.position.y + newy
	end
	
	function newT.Set(newx, newy, newrot, newscale)
		newT.position.x = newx
		newT.position.y = newy
		newT.rotation = newrot or newT.rotation
		newT.scale = newscale or newT.scale
	end
	
	function newT.GetNewPosition(newx, newy)
		return newT.position.x + newx, newT.position.y + newy	
	end
	
	function newT.Request(newx, newy, colliderID)
		
		local c = collider.colliders[colliderID]
		local collisions = nil 
		local collisionsY = nil
		
		if c.type == 'box' then
			collisions = collider.overlapBox(newT.position.x + newx, newT.position.y, c.width, c.height)
			collisionsY = collider.overlapBox(newT.position.x, newT.position.y + newy, c.width, c.height)
		else 
			collisions = collider.overlapCircle(newT.position.x + newx, newT.position.y, c.radius)
			collisionsY = collider.overlapCircle(newT.position.x, newT.position.y + newy, c.radius)
		end
		
		local moveMult = {1, 1}
		
		for k,v in pairs(collisions) do
			if v.trigger == false and v.ID ~= c.ID then
				moveMult[1] = 0
				break
			end
		end
		
		for k,v in pairs(collisionsY) do
			if v.trigger == false and v.ID ~= c.ID then
				moveMult[2] = 0
				break
			end
		end
		
		for k,v in pairs(collisionsY) do table.insert(collisions, v) end
		
		for k,v in pairs(collisions) do 
			c.collisions[v.ID] = v
			v.collisions[c.ID] = c
		end

		newT.Translate(newx * moveMult[1], newy * moveMult[2])
	end
	
	function newT.get()
		return newT.position.x, newT.position.y, newT.rotation, newT.scale
	end
	
	return newT
end

return transform