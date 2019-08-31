# LoveCollider

LoveCollider is a very light collider library.
This can either be used just with triggers, or with physics collisions with the help of the transform.lua script

You can read the documentation on the functions here: https://github.com/Baggef/LoveCollider/blob/master/FUNCTIONS.md

## Installation

After downloading, place collider.lua (and transform.lua optionally) into your folder with your main.lua. 
If you put it in a different folder, be sure to reflect that in the following require lines.

In your main.lua or wherever you put your requirements, write
```lua
collider = require('collider')
-- If you installed transform.lua
local transform = require('transform')
```
transform.lua requires collider to be global, but if you dont need the physics side, you can set collider to local and leave out transform.

In your update function, add this
```lua
collider.update()
```

and you're done

## Examples

I'm going to show you a very simple way of setting up both a trigger collider, and a physics collider

### Trigger

A trigger collider is very simple and what I intended this script to be for.

A simple trigger collider can be made with the function:

```lua
--            x, y, width, height, tag, trigger
myTrigger = collider.newBox(0, 0, 100, 100, 'tag', true)
```
Where collider is the name of the table returned from require('collider')

This can be expanded upon with functions,
here is an example of a trigger that activates when a collider with the tag 'player' enters:
```lua
function myTrigger.onTriggerEnter(other)
  if other.tag == 'player' then
    print('Hello player!')
  end
end
```
OnTriggerEnter is called on both colliders during an interaction, even if it's not a trigger.
There is also a onTriggerExit function that takes the same parameters and triggers when a collider has left the trigger

If you want a more temporary trigger, you can use this function:
```lua
--                                x, y, width, height
collisions = collider.overlapBox(100, 100, 200, 200)
```
Where collider is the name of the table returned from require('collider')

This returns all of the colliders that where inside of that box during that frame. 
This can be used for hit detection and other instantanious checks.

Both of these functions have a circle variant.
```lua
--                 x, y, radius, tag, trigger
collider.newCircle(100, 100, 10, 'tag', true)
--                      x, y, radius
collider.overlapCircle(100, 100, 10)
```
### Physics
The physics collisions (like running into a wall) are more tricky.

#### Currently, the circle colliders do not work with physics.

If you wanted to make something like a wall, setting the trigger parameter to false will make one.
But not so fast, if you want them to collide, you're going to need the transform.lua script.
If you already have a transform.lua script, you can just take the Request() and Translate() functions and rework them to fit yours, it's pretty simple lua so don't worry.

The thing that is going to be colliding with the walls needs to move a certain way, and that is with the Request() function. 
Here is an example of a player I created to test this:

```lua
function love.load()
	player.movespeed = 20
	player.box = collider.newBox(0, 0, player.sprite:getWidth()*player.transform.scale, player.sprite:getHeight()*player.transform.scale, 'player', false, {0,0,1})
end

function love.update(dt)
	local movement = vector2.new(input.getAxis('Horizontal'), input.getAxis('Vertical'))
	movement = vector2.mult(movement, player.movespeed * dt)
  
	player.transform.Request(movement.x, movement.y, player.box.ID)
	player.box.updatePos(player.transform.position.x, player.transform.position.y, false)
end
```
Now dont worry about movement or any math before, just focus on Request() and updatePos()
Request() takes your current movement incriments and your collider's ID and tests if that collider would be able to go there.
updatePos() updates the position of the player's collider, the last parameter asks whether to use the center of the collider as the point to move.

### Debugging
The colliders are invisible, if you would like to view the colliders in your game, simply run this code snippet:
```lua
function love.draw()
  collider.draw()
end
```
Where collider is the name of the table returned from require('collider'). 
This will draw every collider in the game.

You can set the color of the collider when drawn as the last parameter of newBox() or by setting
```lua
myCollider.debugColor = {1,1,1}
```
