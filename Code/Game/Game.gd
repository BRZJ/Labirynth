@tool
extends Node3D
@onready var labyrinth := $Labyrinth
@onready var player := $"Labyrinth/Player Character"
var playerCoords := Vector3()

var playerSettings = null
var playerWindowSettings = null
var playerSensitivity = 0.004
var gameDifficulty = 2   # (0, Easy)(1, Medium)(2, Hard)
var githubLink = null

func _ready():
	labyrinth.set_start(false)
	init_Game_Menu()

func init_Game_Menu():
	print("Game Start")
	# MAIN MENU
	# < Insert A Game Name Here>
	# SETTINGS: 1. Controls:  A: WASD <DEFAULT> B. Arrows
	#           2. Window Settings
	#           3. Camera Sensitivity   <DEFAULT = 0.004>
	# START GAME: Difficulty: A. Easy   10x10 start     <DEFAULT>
	#                         B. Medium 15x15 start
	#                         C. Hard   25x25 start
	# Load Seed   <later in development cycle>
	# Link to Github 
	# Close Game
	
	#IF USER PRESSES START: 
	
	if gameDifficulty == 0:
		print("Game Diff 0")
		labyrinth.setBorderSize(10)
		labyrinth.setRoom_number(6)
		labyrinth.set_start(true)
		labyrinth.setBorderSize(10)
		
	elif gameDifficulty == 1:
		print("Game Diff 1")
		labyrinth.setBorderSize(15)
		labyrinth.setRoom_number(12)
		labyrinth.set_start(true)
		labyrinth.setBorderSize(15)
	elif gameDifficulty == 2:
		print("Game Diff 2")
		labyrinth.setBorderSize(25)
		labyrinth.setRoom_number(16)
		labyrinth.set_start(true)
		labyrinth.setBorderSize(25)
	else:
		init_Game_Menu()
	
	
	#Close game
	#if event is InputEventKey:
	#if (event as InputEventKey).scancode == KEY_ESCAPE:
	 #   get_root().quit()
