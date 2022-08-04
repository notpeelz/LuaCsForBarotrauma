-- luacheck: ignore 111

--[[--
FarseerPhysics.Dynamics.World
]]
-- @code Game.World
-- @pragma nostrip
local World = {}

--- Add
-- @realm shared
-- @tparam Body body
function Add(body) end

--- Remove
-- @realm shared
-- @tparam Body body
function Remove(body) end

--- Add
-- @realm shared
-- @tparam Joint joint
function Add(joint) end

--- Remove
-- @realm shared
-- @tparam Joint joint
function Remove(joint) end

--- AddAsync
-- @realm shared
-- @tparam Body body
function AddAsync(body) end

--- RemoveAsync
-- @realm shared
-- @tparam Body body
function RemoveAsync(body) end

--- AddAsync
-- @realm shared
-- @tparam Joint joint
function AddAsync(joint) end

--- RemoveAsync
-- @realm shared
-- @tparam Joint joint
function RemoveAsync(joint) end

--- ProcessChanges
-- @realm shared
function ProcessChanges() end

--- Step
-- @realm shared
-- @tparam TimeSpan dt
function Step(dt) end

--- Step
-- @realm shared
-- @tparam TimeSpan dt
-- @tparam SolverIterations& iterations
function Step(dt, iterations) end

--- Step
-- @realm shared
-- @tparam number dt
function Step(dt) end

--- Step
-- @realm shared
-- @tparam number dt
-- @tparam SolverIterations& iterations
function Step(dt, iterations) end

--- ClearForces
-- @realm shared
function ClearForces() end

--- QueryAABB
-- @realm shared
-- @tparam function callback
-- @tparam AABB& aabb
function QueryAABB(callback, aabb) end

--- QueryAABB
-- @realm shared
-- @tparam AABB& aabb
-- @treturn table
function QueryAABB(aabb) end

--- RayCast
-- @realm shared
-- @tparam function callback
-- @tparam Vector2 point1
-- @tparam Vector2 point2
-- @tparam Category collisionCategory
function RayCast(callback, point1, point2, collisionCategory) end

--- RayCast
-- @realm shared
-- @tparam Vector2 point1
-- @tparam Vector2 point2
-- @treturn table
function RayCast(point1, point2) end

--- Add
-- @realm shared
-- @tparam Controller controller
function Add(controller) end

--- Remove
-- @realm shared
-- @tparam Controller controller
function Remove(controller) end

--- TestPoint
-- @realm shared
-- @tparam Vector2 point
-- @treturn Fixture
function TestPoint(point) end

--- TestPointAll
-- @realm shared
-- @tparam Vector2 point
-- @treturn table
function TestPointAll(point) end

--- ShiftOrigin
-- @realm shared
-- @tparam Vector2 newOrigin
function ShiftOrigin(newOrigin) end

--- Clear
-- @realm shared
function Clear() end

--- CreateBody
-- @realm shared
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateBody(position, rotation, bodyType) end

--- CreateEdge
-- @realm shared
-- @tparam Vector2 start
-- @tparam Vector2 endparam
-- @treturn Body
function CreateEdge(start, endparam) end

--- CreateChainShape
-- @realm shared
-- @tparam Vertices vertices
-- @tparam Vector2 position
-- @treturn Body
function CreateChainShape(vertices, position) end

--- CreateLoopShape
-- @realm shared
-- @tparam Vertices vertices
-- @tparam Vector2 position
-- @treturn Body
function CreateLoopShape(vertices, position) end

--- CreateRectangle
-- @realm shared
-- @tparam number width
-- @tparam number height
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateRectangle(width, height, density, position, rotation, bodyType) end

--- CreateCircle
-- @realm shared
-- @tparam number radius
-- @tparam number density
-- @tparam Vector2 position
-- @tparam BodyType bodyType
-- @treturn Body
function CreateCircle(radius, density, position, bodyType) end

--- CreateEllipse
-- @realm shared
-- @tparam number xRadius
-- @tparam number yRadius
-- @tparam number edges
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateEllipse(xRadius, yRadius, edges, density, position, rotation, bodyType) end

--- CreatePolygon
-- @realm shared
-- @tparam Vertices vertices
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreatePolygon(vertices, density, position, rotation, bodyType) end

--- CreateCompoundPolygon
-- @realm shared
-- @tparam table list
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateCompoundPolygon(list, density, position, rotation, bodyType) end

--- CreateGear
-- @realm shared
-- @tparam number radius
-- @tparam number numberOfTeeth
-- @tparam number tipPercentage
-- @tparam number toothHeight
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateGear(radius, numberOfTeeth, tipPercentage, toothHeight, density, position, rotation, bodyType) end

--- CreateCapsule
-- @realm shared
-- @tparam number height
-- @tparam number topRadius
-- @tparam number topEdges
-- @tparam number bottomRadius
-- @tparam number bottomEdges
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateCapsule(height, topRadius, topEdges, bottomRadius, bottomEdges, density, position, rotation, bodyType) end

--- CreateCapsuleHorizontal
-- @realm shared
-- @tparam number width
-- @tparam number endRadius
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateCapsuleHorizontal(width, endRadius, density, position, rotation, bodyType) end

--- CreateCapsule
-- @realm shared
-- @tparam number height
-- @tparam number endRadius
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateCapsule(height, endRadius, density, position, rotation, bodyType) end

--- CreateRoundedRectangle
-- @realm shared
-- @tparam number width
-- @tparam number height
-- @tparam number xRadius
-- @tparam number yRadius
-- @tparam number segments
-- @tparam number density
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateRoundedRectangle(width, height, xRadius, yRadius, segments, density, position, rotation, bodyType) end

--- CreateLineArc
-- @realm shared
-- @tparam number radians
-- @tparam number sides
-- @tparam number radius
-- @tparam bool closed
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateLineArc(radians, sides, radius, closed, position, rotation, bodyType) end

--- CreateSolidArc
-- @realm shared
-- @tparam number density
-- @tparam number radians
-- @tparam number sides
-- @tparam number radius
-- @tparam Vector2 position
-- @tparam number rotation
-- @tparam BodyType bodyType
-- @treturn Body
function CreateSolidArc(density, radians, sides, radius, position, rotation, bodyType) end

--- CreateChain
-- @realm shared
-- @tparam Vector2 start
-- @tparam Vector2 endparam
-- @tparam number linkWidth
-- @tparam number linkHeight
-- @tparam number numberOfLinks
-- @tparam number linkDensity
-- @tparam bool attachRopeJoint
-- @treturn Path
function CreateChain(start, endparam, linkWidth, linkHeight, numberOfLinks, linkDensity, attachRopeJoint) end

--- GetType
-- @realm shared
-- @treturn Type
function GetType() end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- Equals
-- @realm shared
-- @tparam Object obj
-- @treturn bool
function Equals(obj) end

--- GetHashCode
-- @realm shared
-- @treturn number
function GetHashCode() end

---
-- Fluid, Field of type FluidSystem2
-- @realm shared
-- @FluidSystem2 Fluid

---
-- UpdateTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan UpdateTime

---
-- ContinuousPhysicsTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan ContinuousPhysicsTime

---
-- ControllersUpdateTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan ControllersUpdateTime

---
-- AddRemoveTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan AddRemoveTime

---
-- NewContactsTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan NewContactsTime

---
-- ContactsUpdateTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan ContactsUpdateTime

---
-- SolveUpdateTime, Field of type TimeSpan
-- @realm shared
-- @TimeSpan SolveUpdateTime

---
-- ProxyCount, Field of type number
-- @realm shared
-- @number ProxyCount

---
-- ContactCount, Field of type number
-- @realm shared
-- @number ContactCount

---
-- IsLocked, Field of type bool
-- @realm shared
-- @bool IsLocked

---
-- ContactList, Field of type ContactListHead
-- @realm shared
-- @ContactListHead ContactList

---
-- Enabled, Field of type bool
-- @realm shared
-- @bool Enabled

---
-- Island, Field of type Island
-- @realm shared
-- @Island Island

---
-- Tag, Field of type Object
-- @realm shared
-- @Object Tag

---
-- BodyAdded, Field of type BodyDelegate
-- @realm shared
-- @BodyDelegate BodyAdded

---
-- BodyRemoved, Field of type BodyDelegate
-- @realm shared
-- @BodyDelegate BodyRemoved

---
-- FixtureAdded, Field of type FixtureDelegate
-- @realm shared
-- @FixtureDelegate FixtureAdded

---
-- FixtureRemoved, Field of type FixtureDelegate
-- @realm shared
-- @FixtureDelegate FixtureRemoved

---
-- JointAdded, Field of type JointDelegate
-- @realm shared
-- @JointDelegate JointAdded

---
-- JointRemoved, Field of type JointDelegate
-- @realm shared
-- @JointDelegate JointRemoved

---
-- ControllerAdded, Field of type ControllerDelegate
-- @realm shared
-- @ControllerDelegate ControllerAdded

---
-- ControllerRemoved, Field of type ControllerDelegate
-- @realm shared
-- @ControllerDelegate ControllerRemoved

---
-- ControllerList, Field of type table
-- @realm shared
-- @table ControllerList

---
-- Gravity, Field of type Vector2
-- @realm shared
-- @Vector2 Gravity

---
-- ContactManager, Field of type ContactManager
-- @realm shared
-- @ContactManager ContactManager

---
-- BodyList, Field of type table
-- @realm shared
-- @table BodyList

---
-- JointList, Field of type table
-- @realm shared
-- @table JointList

