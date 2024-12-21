extends CharacterBody3D

const  CROUCH_VELOCITY = 0.5
const  SPRINT_VELOCITY = 2
const  SPEED = 5
@export var JUMP_VELOCITY = 10
@export var fall_damage_threshold = 10

@onready var pause_menu = $PauseMenu
@onready var cam = $head/Camera3D

@export_category("Holding Objects")
@export var throwForce = 7.5
@export var followSpeed = 5.0
@export var followDistance = 2.5
@export var maxDistanceFromCamera = 5.0
@export var dropBelowPlayer = false
@export var groundRay: RayCast3D

@onready var interactRay = $head/Camera3D/InteractRay
var heldObject : RigidBody3D


var walkingSpeed = 0.5
var crouchingSpeed = 3.5
var crawlSpeed = 2.5
 
var trueSpeed = walkingSpeed
 
var isCrouching = false
var isCrawling = false

var old_vel : float = 0.0

@onready var camera = $head/Camera3D
@onready var anim = $AnimationPlayer
@onready var progress_bar = $ProgressBar

func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	if Input.is_action_just_pressed("quit"):
		pause_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	handle_holding_objects()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("crouch"):
		if isCrouching == false:
			movementStateChange("crouch")
			trueSpeed = crouchingSpeed
			
		elif isCrouching == true:
			movementStateChange("uncrouch")
			trueSpeed = walkingSpeed
			
	elif Input.is_action_just_pressed("crawl"):
		if isCrawling == false:
			movementStateChange("crawl")
			trueSpeed = crawlSpeed
		elif isCrawling == true:
			movementStateChange("uncrawl")
			trueSpeed = walkingSpeed
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# sprint
		if Input.is_action_pressed("sprint"):
			velocity.z *= SPRINT_VELOCITY
			velocity.x *= SPRINT_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("crouch"):
			pass
	
	
	move_and_slide()
	
	# fall demage
	if old_vel < 0:
		var diff = velocity.y - old_vel
		if diff > fall_damage_threshold:
			hurt(diff - fall_damage_threshold)
	old_vel = velocity.y 


func movementStateChange(changeType):
	match changeType:
		"crouch":
			if isCrawling:
				$AnimationPlayer.play_backwards("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrouch")
			isCrouching = true
			changeCollisionShapeTo("crouching")
			isCrawling = false
			
		"uncrouch":
			$AnimationPlayer.play_backwards("StandingToCrouch")
			isCrouching = false
			isCrawling = false
			changeCollisionShapeTo("standing")

		"crawl":
			if isCrouching:
				$AnimationPlayer.play("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrawl")
			isCrouching = false
			isCrawling = true
			changeCollisionShapeTo("crawling")

		"uncrawl":
			$AnimationPlayer.play_backwards("StandingToCrawl")
			isCrawling = false
			isCrouching = false
			changeCollisionShapeTo("standing")

#Change collision shapes for standing, crouch, crawl
func changeCollisionShapeTo(shape):
	match shape:
		"crouching":
			#Disabled == false is enabled!
			$CrouchingCollisionShape.disabled = false
			$CrawlingCollisionShape.disabled = true
			$StadingCollisionShape.disabled = true
		"standing":
			#Disabled == false is enabled!
			$StadingCollisionShape.disabled = false
			$CrawlingCollisionShape.disabled = true
			$CrouchingCollisionShape.disabled = true
		"crawling":
			#Disabled == false is enabled!
			$CrawlingCollisionShape.disabled = false
			$StadingCollisionShape.disabled = true
			$CrouchingCollisionShape.disabled = true


func hurt(damage : float):
	progress_bar.value -= damage


func set_held_object(body):
	if body is RigidBody3D:
		heldObject = body
	
func drop_held_object():
	heldObject = null
	
func throw_held_object():
	var obj = heldObject
	drop_held_object()
	obj.apply_central_impulse(-camera.global_basis.z * throwForce * 10)
	
func handle_holding_objects():
	# Throwing Objects
	if Input.is_action_just_pressed("throw"):
		if heldObject != null: throw_held_object()
		
	# Dropping Objects
	if Input.is_action_just_pressed("interact"):
		if heldObject != null: drop_held_object()
		elif interactRay.is_colliding(): set_held_object(interactRay.get_collider())
		
	# Object Following
	if heldObject != null:
		var targetPos = camera.global_transform.origin + (camera.global_basis * Vector3(0, 0, -followDistance)) # 2.5 units in front of camera
		var objectPos = heldObject.global_transform.origin # Held object position
		heldObject.linear_velocity = (targetPos - objectPos) * followSpeed # Our desired position
		
		# Drop the object if it's too far away from the camera
		if heldObject.global_position.distance_to(camera.global_position) > maxDistanceFromCamera:
			drop_held_object()
			
		# Drop the object if the player is standing on it (must enable dropBelowPlayer and set a groundRay/RayCast3D below the player)
		if dropBelowPlayer && groundRay.is_colliding():
			if groundRay.get_collider() == heldObject: drop_held_object()
