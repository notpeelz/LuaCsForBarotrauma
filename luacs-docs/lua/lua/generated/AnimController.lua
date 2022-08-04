-- luacheck: ignore 111

--[[--
Barotrauma.AnimController
]]
-- @code AnimController
-- @pragma nostrip
local AnimController = {}

--- UpdateAnim
-- @realm shared
-- @tparam number deltaTime
function UpdateAnim(deltaTime) end

--- DragCharacter
-- @realm shared
-- @tparam Character target
-- @tparam number deltaTime
function DragCharacter(target, deltaTime) end

--- GetSpeed
-- @realm shared
-- @tparam AnimationType type
-- @treturn number
function GetSpeed(type) end

--- GetCurrentSpeed
-- @realm shared
-- @tparam bool useMaxSpeed
-- @treturn number
function GetCurrentSpeed(useMaxSpeed) end

--- GetAnimationParamsFromType
-- @realm shared
-- @tparam AnimationType type
-- @treturn AnimationParams
function GetAnimationParamsFromType(type) end

--- GetHeightFromFloor
-- @realm shared
-- @treturn number
function GetHeightFromFloor() end

--- UpdateUseItem
-- @realm shared
-- @tparam bool allowMovement
-- @tparam Vector2 handWorldPos
function UpdateUseItem(allowMovement, handWorldPos) end

--- Grab
-- @realm shared
-- @tparam Vector2 rightHandPos
-- @tparam Vector2 leftHandPos
function Grab(rightHandPos, leftHandPos) end

--- HoldItem
-- @realm shared
-- @tparam number deltaTime
-- @tparam Item item
-- @tparam Vector2[] handlePos
-- @tparam Vector2 holdPos
-- @tparam Vector2 aimPos
-- @tparam bool aim
-- @tparam number holdAngle
-- @tparam number itemAngleRelativeToHoldAngle
-- @tparam bool aimMelee
function HoldItem(deltaTime, item, handlePos, holdPos, aimPos, aim, holdAngle, itemAngleRelativeToHoldAngle, aimMelee) end

--- HandIK
-- @realm shared
-- @tparam Limb hand
-- @tparam Vector2 pos
-- @tparam number armTorque
-- @tparam number handTorque
-- @tparam number maxAngularVelocity
function HandIK(hand, pos, armTorque, handTorque, maxAngularVelocity) end

--- ApplyPose
-- @realm shared
-- @tparam Vector2 leftHandPos
-- @tparam Vector2 rightHandPos
-- @tparam Vector2 leftFootPos
-- @tparam Vector2 rightFootPos
-- @tparam number footMoveForce
function ApplyPose(leftHandPos, rightHandPos, leftFootPos, rightFootPos, footMoveForce) end

--- ApplyTestPose
-- @realm shared
function ApplyTestPose() end

--- Recreate
-- @realm shared
-- @tparam RagdollParams ragdollParams
function Recreate(ragdollParams) end

--- GetLimb
-- @realm shared
-- @tparam LimbType limbType
-- @tparam bool excludeSevered
-- @treturn Limb
function GetLimb(limbType, excludeSevered) end

--- GetMouthPosition
-- @realm shared
-- @treturn Nullable`1
function GetMouthPosition() end

--- GetColliderBottom
-- @realm shared
-- @treturn Vector2
function GetColliderBottom() end

--- FindLowestLimb
-- @realm shared
-- @treturn Limb
function FindLowestLimb() end

--- ReleaseStuckLimbs
-- @realm shared
function ReleaseStuckLimbs() end

--- HideAndDisable
-- @realm shared
-- @tparam LimbType limbType
-- @tparam number duration
-- @tparam bool ignoreCollisions
function HideAndDisable(limbType, duration, ignoreCollisions) end

--- RestoreTemporarilyDisabled
-- @realm shared
function RestoreTemporarilyDisabled() end

--- Remove
-- @realm shared
function Remove() end

--- SubtractMass
-- @realm shared
-- @tparam Limb limb
function SubtractMass(limb) end

--- SaveRagdoll
-- @realm shared
-- @tparam string fileNameWithoutExtension
function SaveRagdoll(fileNameWithoutExtension) end

--- ResetRagdoll
-- @realm shared
-- @tparam bool forceReload
function ResetRagdoll(forceReload) end

--- ResetJoints
-- @realm shared
function ResetJoints() end

--- ResetLimbs
-- @realm shared
function ResetLimbs() end

--- AddJoint
-- @realm shared
-- @tparam JointParams jointParams
function AddJoint(jointParams) end

--- AddLimb
-- @realm shared
-- @tparam Limb limb
function AddLimb(limb) end

--- RemoveLimb
-- @realm shared
-- @tparam Limb limb
function RemoveLimb(limb) end

--- OnLimbCollision
-- @realm shared
-- @tparam Fixture f1
-- @tparam Fixture f2
-- @tparam Contact contact
-- @treturn bool
function OnLimbCollision(f1, f2, contact) end

--- SeverLimbJoint
-- @realm shared
-- @tparam LimbJoint limbJoint
-- @treturn bool
function SeverLimbJoint(limbJoint) end

--- Flip
-- @realm shared
function Flip() end

--- GetCenterOfMass
-- @realm shared
-- @treturn Vector2
function GetCenterOfMass() end

--- MoveLimb
-- @realm shared
-- @tparam Limb limb
-- @tparam Vector2 pos
-- @tparam number amount
-- @tparam bool pullFromCenter
function MoveLimb(limb, pos, amount, pullFromCenter) end

--- ResetPullJoints
-- @realm shared
function ResetPullJoints() end

--- FindHull
-- @realm shared
-- @tparam Nullable`1 worldPosition
-- @tparam bool setSubmarine
function FindHull(worldPosition, setSubmarine) end

--- Teleport
-- @realm shared
-- @tparam Vector2 moveAmount
-- @tparam Vector2 velocityChange
-- @tparam bool detachProjectiles
function Teleport(moveAmount, velocityChange, detachProjectiles) end

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

--- ForceRefreshFloorY
-- @realm shared
function ForceRefreshFloorY() end

--- GetSurfaceY
-- @realm shared
-- @treturn number
function GetSurfaceY() end

--- SetPosition
-- @realm shared
-- @tparam Vector2 simPosition
-- @tparam bool lerp
-- @tparam bool ignorePlatforms
-- @tparam bool forceMainLimbToCollider
-- @tparam bool detachProjectiles
function SetPosition(simPosition, lerp, ignorePlatforms, forceMainLimbToCollider, detachProjectiles) end

--- Hang
-- @realm shared
function Hang() end

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
-- RightHandIKPos, Field of type Vector2
-- @realm shared
-- @Vector2 RightHandIKPos

---
-- LeftHandIKPos, Field of type Vector2
-- @realm shared
-- @Vector2 LeftHandIKPos

---
-- IsAiming, Field of type bool
-- @realm shared
-- @bool IsAiming

---
-- IsAimingMelee, Field of type bool
-- @realm shared
-- @bool IsAimingMelee

---
-- ArmLength, Field of type number
-- @realm shared
-- @number ArmLength

---
-- WalkParams, Field of type GroundedMovementParams
-- @realm shared
-- @GroundedMovementParams WalkParams

---
-- RunParams, Field of type GroundedMovementParams
-- @realm shared
-- @GroundedMovementParams RunParams

---
-- SwimSlowParams, Field of type SwimParams
-- @realm shared
-- @SwimParams SwimSlowParams

---
-- SwimFastParams, Field of type SwimParams
-- @realm shared
-- @SwimParams SwimFastParams

---
-- CurrentAnimationParams, Field of type AnimationParams
-- @realm shared
-- @AnimationParams CurrentAnimationParams

---
-- ForceSelectAnimationType, Field of type AnimationType
-- @realm shared
-- @AnimationType ForceSelectAnimationType

---
-- CurrentGroundedParams, Field of type GroundedMovementParams
-- @realm shared
-- @GroundedMovementParams CurrentGroundedParams

---
-- CurrentSwimParams, Field of type SwimParams
-- @realm shared
-- @SwimParams CurrentSwimParams

---
-- CanWalk, Field of type bool
-- @realm shared
-- @bool CanWalk

---
-- IsMovingBackwards, Field of type bool
-- @realm shared
-- @bool IsMovingBackwards

---
-- IsMovingFast, Field of type bool
-- @realm shared
-- @bool IsMovingFast

---
-- AllAnimParams, Field of type table
-- @realm shared
-- @table AllAnimParams

---
-- AimSourceWorldPos, Field of type Vector2
-- @realm shared
-- @Vector2 AimSourceWorldPos

---
-- AimSourcePos, Field of type Vector2
-- @realm shared
-- @Vector2 AimSourcePos

---
-- AimSourceSimPos, Field of type Vector2
-- @realm shared
-- @Vector2 AimSourceSimPos

---
-- HeadPosition, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 HeadPosition

---
-- TorsoPosition, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 TorsoPosition

---
-- HeadAngle, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 HeadAngle

---
-- TorsoAngle, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 TorsoAngle

---
-- StepSize, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 StepSize

---
-- AnimationTestPose, Field of type bool
-- @realm shared
-- @bool AnimationTestPose

---
-- WalkPos, Field of type number
-- @realm shared
-- @number WalkPos

---
-- IsAboveFloor, Field of type bool
-- @realm shared
-- @bool IsAboveFloor

---
-- RagdollParams, Field of type RagdollParams
-- @realm shared
-- @RagdollParams RagdollParams

---
-- Limbs, Field of type Limb[]
-- @realm shared
-- @Limb[] Limbs

---
-- HasMultipleLimbsOfSameType, Field of type bool
-- @realm shared
-- @bool HasMultipleLimbsOfSameType

---
-- Frozen, Field of type bool
-- @realm shared
-- @bool Frozen

---
-- Character, Field of type Character
-- @realm shared
-- @Character Character

---
-- OnGround, Field of type bool
-- @realm shared
-- @bool OnGround

---
-- ColliderHeightFromFloor, Field of type number
-- @realm shared
-- @number ColliderHeightFromFloor

---
-- IsStuck, Field of type bool
-- @realm shared
-- @bool IsStuck

---
-- Collider, Field of type PhysicsBody
-- @realm shared
-- @PhysicsBody Collider

---
-- ColliderIndex, Field of type number
-- @realm shared
-- @number ColliderIndex

---
-- FloorY, Field of type number
-- @realm shared
-- @number FloorY

---
-- Mass, Field of type number
-- @realm shared
-- @number Mass

---
-- MainLimb, Field of type Limb
-- @realm shared
-- @Limb MainLimb

---
-- WorldPosition, Field of type Vector2
-- @realm shared
-- @Vector2 WorldPosition

---
-- SimplePhysicsEnabled, Field of type bool
-- @realm shared
-- @bool SimplePhysicsEnabled

---
-- TargetMovement, Field of type Vector2
-- @realm shared
-- @Vector2 TargetMovement

---
-- ImpactTolerance, Field of type number
-- @realm shared
-- @number ImpactTolerance

---
-- Draggable, Field of type bool
-- @realm shared
-- @bool Draggable

---
-- CanEnterSubmarine, Field of type bool
-- @realm shared
-- @bool CanEnterSubmarine

---
-- Dir, Field of type number
-- @realm shared
-- @number Dir

---
-- Direction, Field of type Direction
-- @realm shared
-- @Direction Direction

---
-- InWater, Field of type bool
-- @realm shared
-- @bool InWater

---
-- HeadInWater, Field of type bool
-- @realm shared
-- @bool HeadInWater

---
-- CurrentHull, Field of type Hull
-- @realm shared
-- @Hull CurrentHull

---
-- IgnorePlatforms, Field of type bool
-- @realm shared
-- @bool IgnorePlatforms

---
-- IsFlipped, Field of type bool
-- @realm shared
-- @bool IsFlipped

---
-- BodyInRest, Field of type bool
-- @realm shared
-- @bool BodyInRest

---
-- Invalid, Field of type bool
-- @realm shared
-- @bool Invalid

---
-- IsHanging, Field of type bool
-- @realm shared
-- @bool IsHanging

---
-- Anim, Field of type Animation
-- @realm shared
-- @Animation Anim

---
-- LimbJoints, Field of type LimbJoint[]
-- @realm shared
-- @LimbJoint[] LimbJoints

---
-- movement, Field of type Vector2
-- @realm shared
-- @Vector2 movement

---
-- Stairs, Field of type Structure
-- @realm shared
-- @Structure Stairs

---
-- TargetDir, Field of type Direction
-- @realm shared
-- @Direction TargetDir

---
-- forceStanding, Field of type bool
-- @realm shared
-- @bool forceStanding

---
-- forceNotStanding, Field of type bool
-- @realm shared
-- @bool forceNotStanding

