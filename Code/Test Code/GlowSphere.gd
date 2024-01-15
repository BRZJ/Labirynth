extends CharacterBody3D

var speed = 15
var accel = 10

var time_of_last_random_point
var current_time
var random_rate_min: float = 2.0
var random_rate_max: float = 5.0
var current_random_rate
var bounds: float = 60.0

var random_target_position: Vector3 

var nav: NavigationAgent3D 

var physics_frame_one: bool = true

@onready var label: Label = $Label

func _ready():
	time_of_last_random_point = Time.get_unix_time_from_system()
	current_random_rate = randf_range(random_rate_min, random_rate_max)
	nav = $NavigationAgent3D

func _physics_process(delta):
	if physics_frame_one == true:
		physics_frame_one = false
		return 
	
	current_time = Time.get_unix_time_from_system()
	
	var direction = Vector3()
	
	if current_time - time_of_last_random_point > current_random_rate:
		random_target_position = Vector3(randf_range(bounds, -bounds), position.y, randf_range(bounds, -bounds))
		current_random_rate = randf_range(random_rate_min, random_rate_max)
		time_of_last_random_point = Time.get_unix_time_from_system()
	
	
	nav.target_position = random_target_position
	
	direction = nav.get_next_path_position()
	direction = direction.normalized()
	
	velocity = direction * speed

	label.text = str(random_target_position)
	
	move_and_slide()
