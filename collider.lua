-- Collider v2.0

local collider = {}

collider.colliders = {}
collider.boxIDs = {}
collider.circleIDs = {}

function collider.newBox(x, y, width, height, tag, trigger, debugColor)

	local newBox = {}
	
	newBox.x = x
	newBox.y = y
	newBox.width = width
	newBox.height = height or newBox.width
	newBox.tag = tag or 'none'
	if trigger == nil then
		newBox.trigger = false
	else
		newBox.trigger = trigger
	end
	newBox.debugColor = debugColor or {1,1,1}
	
	newBox.ID = tostring('B'..#collider.boxIDs+1)
	newBox.onTriggerEnter = onTriggerEnter or function(collider) end
	newBox.onTriggerExit = onTriggerExit or function(collider) end
	newBox.collisions = {}
	newBox.lastFrameCollisions = {}
	
	newBox.type = 'box'
	
	newBox.superPoints = {
		{
			x = newBox.x,
			y = newBox.y
		},
		{
			x = newBox.x + newBox.width,
			y = newBox.y + newBox.height
		},
		
		updatePoint = function(point, x, y)
			newBox.superPoints[point].x = x
			newBox.superPoints[point].y = y
		end
	}
	
	function newBox.updatePos(newX, newY, center)
		if center == nil then
			center = false
		end
	
		if center == true then
			newBox.x = newX - newBox.width/2
			newBox.y = newY - newBox.height/2
		else
			newBox.x = newX
			newBox.y = newY
		end
		
		newBox.superPoints.updatePoint(1, newBox.x, newBox.y)
		newBox.superPoints.updatePoint(2, newBox.x + newBox.width, newBox.y + newBox.height)
	end
	
	function newBox.collidingWith(id) 
		return newBox.collisions[id] ~= nil
	end
	
	function newBox.getID()
		return newBox.ID
	end
	
	-- NOT WORKING
	function newBox.destroy()
		for k,v in ipairs(collider.boxIDs) do
			if v == newBox.ID then
				v = nil
			end
		end
		collider.colliders[newBox.ID] = nil
	end
	
	collider.colliders[newBox.ID] = newBox
	newBox.IDindex = #collider.boxIDs + 1
	collider.boxIDs[newBox.IDindex] = newBox.ID
	
	return newBox

end

function collider.newCircle(x, y, radius, tag, trigger, debugColor)
	
	local newCircle = {}
	
	newCircle.x = x
	newCircle.y = y
	newCircle.radius = radius or 50
	newCircle.tag = tag or 'none'
	if trigger == nil then
		newCircle.trigger = false
	else
		newCircle.trigger = trigger
	end
	newCircle.debugColor = debugColor or {1,1,1}
	
	newCircle.ID = tostring('C'..#collider.circleIDs+1)
	newCircle.onTriggerEnter = onTriggerEnter or function(collider) end
	newCircle.onTriggerExit = onTriggerExit or function(collider) end
	newCircle.collisions = {}
	newCircle.lastFrameCollisions = {}
	
	newCircle.type = 'circle'
	
	function newCircle.updatePos(newX, newY)
		newCircle.x = newX
		newCircle.y = newY
	end
	
	function newCircle.collidingWith(id) 
		return newCircle.collisions[id] ~= nil
	end
	
	function newCircle.getID()
		return newCircle.ID
	end
	
	-- NOT WORKING
	function newCircle.destroy()
		for k,v in ipairs(collider.circleIDs) do
			if v == newCircle.ID then
				v = nil
			end
		end
		collider.colliders[newCircle.ID] = nil
	end
	
	collider.colliders[newCircle.ID] = newCircle
	newCircle.IDindex = #collider.circleIDs + 1
	collider.circleIDs[newCircle.IDindex] = newCircle.ID
	
	return newCircle
	
end

function collider.update()	
	collider.updateBoxes()
	collider.updateCircles()
end

function collider.overlapBox(boxX, boxY, width, height)

	local collisions = {}
	
	local superPoints = {
		{
			x = boxX,
			y = boxY
		},
		{
			x = boxX + width,
			y = boxY + height
		},
	}
	
	-- Against every other box
	for kk,other in ipairs(collider.boxIDs) do
		other = collider.colliders[other]
		
		-- Look for an x plane and y plane intersection in superPoints
		local spX = {false, false}
		local spY = {false, false}
		
		-- Loop through superPoints
		for kkk,sp in ipairs(superPoints) do
			if sp.x > other.superPoints[1].x and sp.x < other.superPoints[2].x then
				spY[kkk] = true
			end
			
			if sp.y > other.superPoints[1].y and sp.y < other.superPoints[2].y then
				spX[kkk] = true
			end
		end
		
		-- Check if superPoints show a collision between my and other
		if (spX[1] and spY[1]) or (spX[2] and spY[2]) or (spX[1] and spY[2]) or (spX[2] and spY[1]) then
			collisions[other.ID] = other
		end
	end
	
	-- Against every other circle
	for kk,other in ipairs(collider.circleIDs) do
		other = collider.colliders[other]
		
		local testX = other.x
		local testY = other.y
		
		if (other.x < boxX) then
			testX = boxX                  -- left edge
		elseif (other.x > boxX + width) then
			testX = boxY + width          -- right edge
		end
		
		if (other.y < boxY) then
			testY = boxY                  -- top edge
		elseif (other.y > boxY + height) then
			testY = boxY + height         -- bottom edge
		end
		
		local distX = other.x - testX;
		local distY = other.y - testY;
		local distance = (distX * distX) + (distY * distY);
		
		if distance <= other.radius * other.radius then
			collisions[other.ID] = other
		end
	end		
	
	return collisions
end

function collider.overlapCircle(x, y, radius)

	local collisions = {}
	
	-- Against every other box
	for kk,other in ipairs(collider.boxIDs) do
		other = collider.colliders[other]
			
		local testX = x
		local testY = y
			
		if (x < other.x) then
			testX = other.x                  -- left edge
		elseif (x > other.x + other.width) then
			testX = other.x + other.width       -- right edge
		end

		if (y < other.y) then
			testY = other.y                  -- top edge
		elseif (y > other.y + other.height) then
			testY = other.y + other.height      -- bottom edge
		end
			
		local distX = x - testX;
		local distY = y - testY;
		local distance = (distX * distX) + (distY * distY);
		
		if distance <= radius * radius then
			collisions[other.ID] = other
		end
	end

	-- Against every other circle
	for kk,other in ipairs(collider.circleIDs) do
		other = collider.colliders[other]
		
		local distX = x - other.x;
		local distY = y - other.y;
		local distance = (distX*distX) + (distY*distY);

		if (distance <= (radius+other.radius) * (radius+other.radius)) then
			collisions[other.ID] = other
		end
	end		
	
	return collisions
end

function collider.updateBoxes()

	for k,v in ipairs(collider.boxIDs) do
		v = collider.colliders[v]
		
		for kk in pairs (v.collisions) do
			v.collisions[kk] = nil
		end
	end
	
	-- Check every box for any collisions
	for k,my in ipairs(collider.boxIDs) do
		my = collider.colliders[my]
		
		-- Against every other box
		for kk,other in ipairs(collider.boxIDs) do
			other = collider.colliders[other]
			
			-- Ignore if it is yourself
			if kk ~= k then
				
				-- Look for an x plane and y plane intersection in superPoints
				local spX = {false, false}
				local spY = {false, false}
				
				-- Loop through superPoints
				for kkk,sp in ipairs(my.superPoints) do
					if sp.x > other.superPoints[1].x and sp.x < other.superPoints[2].x then
						spY[kkk] = true
					end
					
					if sp.y > other.superPoints[1].y and sp.y < other.superPoints[2].y then
						spX[kkk] = true
					end
				end
				
				-- Check if superPoints show a collision between my and other
				if (spX[1] and spY[1]) or (spX[2] and spY[2]) or (spX[1] and spY[2]) or (spX[2] and spY[1]) then
					if not my.collisions[other.ID] ~= nil or not other.collisions[my.ID] ~= nil then
						my.collisions[other.ID] = other
						other.collisions[my.ID] = my
					end
				end
			end
		end
		
		-- Against every other circle
		for kk,other in ipairs(collider.circleIDs) do
			other = collider.colliders[other]
			
			local testX = other.x
			local testY = other.y
				
			if (other.x < my.x) then
				testX = my.x                  -- left edge
			elseif (other.x > my.x + my.width) then
				testX = my.x + my.width       -- right edge
			end

			if (other.y < my.y) then
				testY = my.y                  -- top edge
			elseif (other.y > my.y + my.height) then
				testY = my.y + my.height      -- bottom edge
			end
				
			local distX = other.x - testX;
			local distY = other.y - testY;
			local distance = (distX * distX) + (distY * distY);
				
			if distance <= other.radius * other.radius then
				my.collisions[other.ID] = other
				other.collisions[my.ID] = my
			end
		end		
	end
	
	-- Update collision status
	for k,my in ipairs(collider.boxIDs) do
		my = collider.colliders[my]
		
		for kk,other in pairs(my.collisions) do
		
			-- Check if its a new collision
			if my.lastFrameCollisions[other.ID] == nil then
			
				my.lastFrameCollisions[other.ID] = other
				
				my.onTriggerEnter(collider.colliders[other.ID])
				collider.colliders[other.ID].lastFrameCollisions[my.ID] = my
				collider.colliders[other.ID].onTriggerEnter(my)
			end
		end
		
		for kk,other in pairs(my.lastFrameCollisions) do
		
			-- Check if collisions from last frame aren't there anymore
			if my.collisions[other.ID] == nil then
			
				my.lastFrameCollisions[other.ID] = nil

				my.onTriggerExit(collider.colliders[other.ID])
				collider.colliders[other.ID].lastFrameCollisions[my.ID] = nil
				collider.colliders[other.ID].onTriggerExit(my)
			end
		end
	end
end

function collider.updateCircles()

	for k,v in ipairs(collider.circleIDs) do
		v = collider.colliders[v]
		
		for kk in pairs (v.collisions) do
			v.collisions[kk] = nil
		end
	end
	
	-- Check every circle
	for k,my in ipairs(collider.circleIDs) do
		my = collider.colliders[my]
	
		-- Against every other box
		for kk,other in ipairs(collider.boxIDs) do
			other = collider.colliders[other]
			
			local testX = my.x
			local testY = my.y
			
			if (my.x < other.x) then
				testX = other.x                  -- left edge
			elseif (my.x > other.x + other.width) then
				testX = other.x + other.width       -- right edge
			end

			if (my.y < other.y) then
				testY = other.y                  -- top edge
			elseif (my.y > other.y + other.height) then
				testY = other.y + other.height      -- bottom edge
			end
				
			local distX = my.x - testX;
			local distY = my.y - testY;
			local distance = (distX * distX) + (distY * distY);
				
			if distance <= my.radius * my.radius then
				my.collisions[other.ID] = other
				other.collisions[my.ID] = my
			end
		end
		
		-- Against every other circle
		for kk,other in ipairs(collider.circleIDs) do
			if k ~= kk then
				other = collider.colliders[other]
			
				local distX = my.x - other.x;
				local distY = my.y - other.y;
				local distance = (distX*distX) + (distY*distY);

				if (distance <= (my.radius+other.radius) * (my.radius+other.radius)) then
					my.collisions[other.ID] = other
					other.collisions[my.ID] = my
				end
			end
		end		
	end
	
	-- Update collision status
	for k,my in ipairs(collider.circleIDs) do
		my = collider.colliders[my]
		
		for kk,other in pairs(my.collisions) do
		
			-- Check if its a new collision
			if my.lastFrameCollisions[other.ID] == nil then
			
				my.lastFrameCollisions[other.ID] = other
				
				my.onTriggerEnter(collider.colliders[other.ID])
				collider.colliders[other.ID].lastFrameCollisions[my.ID] = my
				collider.colliders[other.ID].onTriggerEnter(my)
			end
		end
		
		for kk,other in pairs(my.lastFrameCollisions) do
		
			-- Check if collisions from last frame aren't there anymore
			if my.collisions[other.ID] == nil then
			
				my.lastFrameCollisions[other.ID] = nil

				my.onTriggerExit(collider.colliders[other.ID])
				collider.colliders[other.ID].lastFrameCollisions[my.ID] = nil
				collider.colliders[other.ID].onTriggerExit(my)
			end
		end
	end
end

function collider.draw()
	for k,id in ipairs(collider.boxIDs) do
		local v = collider.colliders[id]
		
		if v ~= nil then
			love.graphics.setColor(v.debugColor)
			love.graphics.rectangle('line', v.x, v.y, v.width, v.height)
			love.graphics.circle('fill', v.x + v.width/2, v.y + v.height/2, 3)
			for kk,vv in ipairs(v.superPoints) do
				love.graphics.circle('fill', vv.x, vv.y, 3)
			end
			love.graphics.print(v.ID, v.x + 5, v.y - 15)
			love.graphics.print(v.tag, v.x + 5, v.y)
		end
	end
	
	for k,id in ipairs(collider.circleIDs) do
		local v = collider.colliders[id]
		
		if v ~= nil then
			love.graphics.setColor(v.debugColor)
			love.graphics.circle('line', v.x, v.y, v.radius)
			love.graphics.circle('fill', v.x, v.y, 3)
			love.graphics.print(v.ID, v.x + 5, v.y - 15)
			love.graphics.print(v.tag, v.x + 5, v.y)
		end
	end
end

return collider