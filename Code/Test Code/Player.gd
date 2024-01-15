extends CharacterBody3D


@export var SPEED = 5.0
const JUMP_VELOCITY = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_multiplier: float = 4.0

@onready var camera := $Camera3D
@onready var camera_start_pos: Vector3 = camera.position
var camera_max_height: float = 4.0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.005)
			#camera.(event.relative.y * 0.01)
			camera.translate(Vector3(0, event.relative.y * 0.01, 0))
			
			if camera.position.y > camera_max_height:
				camera.position.y = camera_max_height
			elif camera.position.y < -camera_max_height:
				camera.position.y = -camera_max_height
			
			camera.position = Vector3(camera_start_pos.x, camera.position.y, camera_start_pos.z) 
			camera.look_at(position)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
