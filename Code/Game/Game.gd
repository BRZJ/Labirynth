@tool
extends Node3D
@onready var labyrinth := $Labyrinth
@onready var player := $"Labyrinth/Player Character/CharacterBody3D"
@onready var timer := $Timer
var playerCoords := Vector3()

var playerSettings = null
var playerWindowSettings = null
var playerSensitivity = 0.004


var gameDifficulty = 2  # (0, Easy)(1, Medium)(2, Hard)

var maxRoomNumber = 120    # ---- MAX ROOMS FOR A 50X50 AREA
var githubLink = null
var expansion
var easyWaitTimeExtension = 6
var easyRoomExpansion = 2
var mediumWaitTimeExtension = 8
var mediumRoomExpansion = 4
var hardWaitTimeExtension = 10
var hardRoomExpansion = 6

func _ready():
	labyrinth.set_start(false)
	init_Game_Menu()

func spawnPlayer():
	print("Spawn player function")
	var rand_room = (randi_range(0,labyrinth.getRoom_Number()-1))
	#print("rand room:", rand_room)
	var rand_room_vector = (labyrinth.getRoomPos())[rand_room]
	#print("get room pos:", labyrinth.getRoomPos())
	#print("rand room V:",rand_room_vector)
	player.setPlayerPosition(rand_room_vector)
	labyrinth.set_inBossRoom(false)

func init_Game_Menu():
	print("Game Start")
	# MAIN MENU
	# < Insert A Game Name Here>
	# SETTINGS: 1. Controls:  A: WASD <DEFAULT> B. Arrows
	#           2. Window Settings
	#           3. Camera Sensitivity   <DEFAULT = 0.004>
	# START GAME: Difficulty: A. Easy   15x15 start  expansion+5   <DEFAULT>  boss room size 4x4  timeToExpand 180s
	#                         B. Medium 25x25 start           +6              boss room size 6x6               240s
	#                         C. Hard   35x35 start           +7              boss room size 8x8               300s
	# Load Seed   <later in development cycle>
	# Link to Github 
	# Close Game
	
	#IF USER PRESSES START: 
	labyrinth.set_inBossRoom(false)
	if gameDifficulty == 0:
		#print("Game Diff 0")
		expansion = 5
		labyrinth.setBorderSize(15)      # border is required to be set before and after start 
		labyrinth.setRoom_number(6)      # or else it will not generate a new map of that size on launch
		labyrinth.set_min_boss_room_size(4)
		labyrinth.set_max_boss_room_size(5)                     
		timer.wait_time = 45
		labyrinth.set_start(true)
		labyrinth.setBorderSize(10)
		
	elif gameDifficulty == 1:
		#print("Game Diff 1")
		expansion = 6
		labyrinth.setBorderSize(25)
		labyrinth.setRoom_number(16)
		labyrinth.set_min_boss_room_size(6)
		labyrinth.set_max_boss_room_size(7)
		timer.wait_time = 60
		labyrinth.set_start(true)
		labyrinth.setBorderSize(15)
	elif gameDifficulty == 2:
		#print("Game Diff 2")
		expansion = 7
		labyrinth.setBorderSize(35)
		labyrinth.setRoom_number(25)
		labyrinth.set_min_boss_room_size(8)
		labyrinth.set_max_boss_room_size(9)
		timer.wait_time = 75
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
	


func _on_timer_timeout():
	#print("TIMER INBOSSROOM ",labyrinth.get_inBossRoom() )
	
	#print("TIMER", Time.get_time_dict_from_system())
	var expand = labyrinth.get_inBossRoom()
	if expand == false:
		#print("line 105")
		var currSize = labyrinth.getBorderSize()
		var currRoom = labyrinth.getRoom_Number()
		#print("---------------------")
		#print("TIMER Room NUMBER: ", currRoom)
		
		if gameDifficulty == 0:
			
			if labyrinth.getRoom_Number() <= maxRoomNumber-easyRoomExpansion:
				print("maxRoomNumber-easyRoomExpansion: ", maxRoomNumber-easyRoomExpansion)
				labyrinth.setRoom_number(currRoom+easyRoomExpansion)    #inc rooms spawning
				timer.wait_time ++ easyWaitTimeExtension                    #inc time to explore new maze
				print("TIMER 2 Room NUMBER: ", labyrinth.getRoom_Number())
				print("--------------------")
				labyrinth.setBorderSize(currSize+expansion)
				labyrinth.generate()
				spawnPlayer()
			else:
				print("Cannot spawn more rooms / expand more. Game over???????????????????????????")
		if gameDifficulty == 1:
			if labyrinth.getRoom_Number() <= maxRoomNumber-mediumRoomExpansion:
				labyrinth.setRoom_number(currRoom+mediumRoomExpansion)
				timer.wait_time ++ mediumWaitTimeExtension
				#print("TIMER 2 Room NUMBER: ", labyrinth.getRoom_Number())
				#print("--------------------")
				labyrinth.setBorderSize(currSize+expansion)
				labyrinth.generate()
				spawnPlayer()
			else:
				print("Cannot spawn more rooms / expand more. Game over???????????????????????????")
		if gameDifficulty == 2:
			#print("(maxRoomNumber-hardRoomExpansion): ", (maxRoomNumber-hardRoomExpansion))
			#print ("labyrinth.getRoom_Number() <= maxRoomNumber-hardRoomExpansion: ", labyrinth.getRoom_Number() <= (maxRoomNumber-hardRoomExpansion))
			if labyrinth.getRoom_Number() <= maxRoomNumber-hardRoomExpansion:
				labyrinth.setRoom_number(currRoom+hardRoomExpansion)
				timer.wait_time ++ hardWaitTimeExtension
				#print("TIMER 2 Room NUMBER: ", labyrinth.getRoom_Number())
				#print("--------------------")
				labyrinth.setBorderSize(currSize+expansion)
				labyrinth.generate()
				spawnPlayer()
			else:
				print("Cannot spawn more rooms / expand more. Game over???????????????????????????")
		else:
			pass
		
		
		
	else:
		print("timer fail")
		pass
