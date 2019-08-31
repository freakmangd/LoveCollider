# Functions

```lua
collider.newBox(x, y, width, height, tag, trigger, debugColor)
collider.newCircle(x, y, radius, tag, trigger, debugColor)
collider.overlapBox(x, y, width, height)
collider.overlapCircle(x, y, radius)
collider.draw()

newCollider.updatePos(x, y, center)
newCollider.collidingWith(id)
newCollider.getID()
```

### Synopsis
```lua
collider.newBox(x, y, width, height, tag, trigger, debugColor)
```
### Arguments

**number** x  
  _x position of new collider_  
  
**number** y  
  _y position of new collider_
  
**number** width  
  _width of new collider_
  
**number** height (width)  
  _height of new collider_
  
**string** tag ("none")  
  _tag for new collider, can be used to distinguish or group colliders; accessed through [collidername].tag_
  
**boolean** trigger (false)  
  _whether the new collider is a trigger, doesn't matter if transform.lua isn't used_
  
**Table** debugColor ({1,1,1})  
  _color of new collider when drawn with collider.draw()_

### Returns
**Table** newBox  
  _reference to the new collider_

### Synopsis
```lua
collider.newCircle(x, y, radius, tag, trigger, debugColor)
```
### Arguments

**number** x  
  _x position of new collider_  
  
**number** y  
  _y position of new collider_
  
**number** radius
  _radius of new collider_
  
**string** tag ("none")  
  _tag for new collider, can be used to distinguish or group colliders; accessed through [collidername].tag_
  
**boolean** trigger (false)  
  _whether the new collider is a trigger, doesn't matter if transform.lua isn't used_
  
**Table** debugColor ({1,1,1})  
  _color of new collider when drawn with collider.draw()_

### Returns
**Table** newCircle  
  _reference to the new collider_

### Synopsis
```lua
collider.overlapBox(x, y, width, height)
```
_Create a disposable collider for one frame, returns all collisions that collider had_
### Arguments

**number** x  
  _x position of collider_  
  
**number** y  
  _y position of collider_
  
**number** width
  _width of collider_

**height**
  _height of collider_
  
### Returns
**Table** collisions
  _table of collisions that collider collided with for the frame it is active_
  
### Synopsis
```lua
collider.overlapCircle(x, y, radius)
```
_Create a disposable collider for one frame, returns all collisions that collider had_
### Arguments

**number** x  
  _x position of collider_  
  
**number** y  
  _y position of collider_
  
**number** radius
  _radius of collider_
  
### Returns
**Table** collisions
  _table of collisions that collider collided with for the frame it is active_
  
### Synopsis
```lua
collider.update()
```
_Update all colliders_
### Arguments

None

### Returns

Nothing
  
### Synopsis
```lua
collider.draw()
```
_Draw all colliders with their debug color_
### Arguments

None

### Returns

Nothing

### Synopsis
```lua
newCollider.updatePos(x, y, center)
```
_Update position of collider_
### Arguments

**number** x
  _New x position of collider_
**number** y
  _New y position of collider_
**boolean** center (false)
  _Whether to use the center of the collider as the point to set instead of the top left corner_
  
### Returns

Nothing

### Synopsis
```lua
newCollider.collidingWith(id)
```
_Check whether a collider is colliding with or inside of another collider by their ID_
### Arguments

**string** id
  _ID of other collider to check collision with, can be got with newCollider.ID or newCollider.getID()_
  
### Returns

**boolean** isColliding
  _Whether or not the collider is colliding with the other collider_

### Synopsis
```lua
newCollider.getID()
```
### Arguments

None

### Returns

**string** id
  _ID of newCollider_
