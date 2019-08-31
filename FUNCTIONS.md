# Functions

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
collider.draw()
```
_Draw all colliders with their debug color_
### Arguments

None

### Returns

Nothing
