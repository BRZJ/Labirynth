@tool
extends Node3D
@onready var labyrinth := $Labyrinth
@onready var player := $"Labyrinth/Player Character"
var playerCoords := Vector3()

func gameSetup():
	print ("Coords:") 
	print(playerCoords)
