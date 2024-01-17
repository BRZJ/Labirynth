@tool
extends Node3D
@onready var labyrinth := $Labyrinth
@onready var player := $"Labyrinth/Player Character/CharacterBody3D"
var playerCoords := Vector3()

var playerSettings = null
var playerWindowSettings = null
var playerSensitivity = 0.004
var gameDifficulty = 2   # (0, Easy)(1, Medium)(2, Hard)
var githubLink = null

func _ready():
	labyrinth.set_start(false)
	init_Game_Menu()

func spawnPlayer():
	print("Spawn player function")
	var rand_room = (randi_range(0,labyrinth.getRoom_Number()-1))
	print("rand room:")
	print(rand_room)
	var rand_room_vector = (labyrinth.getRoomPos())[rand_room]
	print("get room pos:")
	print(labyrinth.getRoomPos())
	print("rand room V:")
	print(rand_room_vector)
	player.setPlayerPosition(rand_room_vector)

func init_Game_Menu():
	print("Game Start")
	# MAIN MENU
	# < Insert A Game Name Here>
	# SETTINGS: 1. Controls:  A: WASD <DEFAULT> B. Arrows
	#           2. Window Settings
	#           3. Camera Sensitivity   <DEFAULT = 0.004>
	# START GAME: Difficulty: A. Easy   10x10 start     <DEFAULT>
	#                         B. Medium 25x25 start
	#                         C. Hard   35x35 start
	# Load Seed   <later in development cycle>
	# Link to Github 
	# Close Game
	
	#IF USER PRESSES START: 
	
	if gameDifficulty == 0:
		#print("Game Diff 0")
		labyrinth.setBorderSize(10)      # border is required to be set before and after start 
		labyrinth.setRoom_number(6)      # or else it will not generate a new map of that size on launch
		labyrinth.set_start(true)
		labyrinth.setBorderSize(10)
		
	elif gameDifficulty == 1:
		#print("Game Diff 1")
		labyrinth.setBorderSize(25)
		labyrinth.setRoom_number(16)
		labyrinth.set_start(true)
		labyrinth.setBorderSize(15)
	elif gameDifficulty == 2:
		#print("Game Diff 2")
		labyrinth.setBorderSize(35)
		labyrinth.setRoom_number(25)
		labyrinth.set_start(true)
		labyrinth.setBorderSize(25)
	else:
		init_Game_Menu()
	
	main_game_loop()
	
	#Close game
	#if event is InputEventKey:
	#if (event as InputEventKey).scancode == KEY_ESCAPE:
	 #   get_root().quit()

	
func main_game_loop():
	print("main game loop function")
	spawnPlayer()
	
