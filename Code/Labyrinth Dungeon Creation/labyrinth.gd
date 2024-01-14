@tool
extends Node3D

@onready var gridMap: GridMap = $LabyrinthMap
@export var start : bool = false : set = set_start 
@export var borderSize : int = 5 : set = set_border
@export var room_number : int = 4
@export var room_margin : int = 1 #min distance between rooms 
@export var room_recursion : int = 15
@export var min_room_size : int = 2 
@export var max_room_size : int = 4
@export_range(0,1) var extraPathChance : float = 0.75
var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []


func set_start(val:bool)->void: 
	generate()
	
func set_border(val:int)->void: 
	borderSize=val
	if Engine.is_editor_hint():
		visualizeBorder()

#Generating rooms
func generate():
	visualizeBorder()
	for i in room_number:
		create_room(room_recursion)
	var rpv2 : PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()  #deloney graph for min spanning tree
	var mst_graph : AStar2D = AStar2D.new()

	for p in room_positions:
		rpv2.append(Vector2(p.x,p.z))
		del_graph.add_point(del_graph.get_available_point_id(),Vector2(p.x,p.z)) #getting points for min spanning tree
		mst_graph.add_point(mst_graph.get_available_point_id(),Vector2(p.x,p.z))

	#triangluation returns indexes for points of min spanning in a array
	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(rpv2))

	#creating deloney graph of triangle paths from prev unvisited points
	for i in delaunay.size()/3:
		var p1 : int = delaunay.pop_front()
		var p2 : int = delaunay.pop_front()
		var p3 : int = delaunay.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)
		
	#Getting Min Spanning Tree
	var visited_points : PackedInt32Array = []
	visited_points.append(randi() % room_positions.size())
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con : PackedInt32Array = [vp,c]
					possible_connections.append(con)
					
		var connection : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) <\
			rpv2[connection[0]].distance_squared_to(rpv2[connection[1]]):
				connection = pc
		
		visited_points.append(connection[1])
		mst_graph.connect_points(connection[0],connection[1])
		del_graph.disconnect_points(connection[0],connection[1]) 
		#End of min span tree
			#adding extra edges back to tree
	var hallway_graph : AStar2D = mst_graph
	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c>p:
				var noExtraPathChance : float = randf()
				if extraPathChance > noExtraPathChance :
					hallway_graph.connect_points(p,c)
					
	create_hallways(hallway_graph)

#Create border square YxY size
func visualizeBorder():
	#remove existing doors, rooms and borders
	room_tiles.clear()    
	gridMap.clear()
	room_positions.clear()
	
	for i in range(-1,borderSize+1):
		gridMap.set_cell_item( Vector3i(i,0,-1),3)
		gridMap.set_cell_item( Vector3i(i,0,borderSize),3)
		gridMap.set_cell_item( Vector3i(borderSize,0,i),3)
		gridMap.set_cell_item( Vector3i(-1,0,i),3)

func create_room(rec:int):
	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector3i 
	
	start_pos.x = randi() % (borderSize - width + 1)
	start_pos.z = randi() % (borderSize - height + 1)
	
	#no room overlapping
	for r in range(-room_margin,height+room_margin):
		for c in range(-room_margin,width+room_margin):
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			if gridMap.get_cell_item(pos) == 0:
				create_room(rec-1)
				return
	
	var room : PackedVector3Array = []
	for r in height:
		for c in width:
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			gridMap.set_cell_item(pos,0)
			room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width)/2)
	var avg_z : float = start_pos.z + (float(height)/2)
	var pos : Vector3 = Vector3(avg_x,0,avg_z)
	room_positions.append(pos)

func create_hallways(hallway_graph:AStar2D):
	var hallways : Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var room_from : PackedVector3Array = room_tiles[p]
				var room_to : PackedVector3Array = room_tiles[c]
				var tile_from : Vector3 = room_from[0]
				var tile_to : Vector3 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c])<\
					tile_from.distance_squared_to(room_positions[c]):
						tile_from = t
				for t in room_to:
					if t.distance_squared_to(room_positions[p])<\
					tile_to.distance_squared_to(room_positions[p]):
						tile_to = t
				var hallway : PackedVector3Array = [tile_from,tile_to]
				hallways.append(hallway)
				gridMap.set_cell_item(tile_from,2)
				gridMap.set_cell_item(tile_to,2)
	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * borderSize
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	for t in gridMap.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x,t.z))
	var _t : int = 0
	for h in hallways:
		_t +=1
		var pos_from : Vector2i = Vector2i(h[0].x,h[0].z)
		var pos_to : Vector2i = Vector2i(h[1].x,h[1].z)
		var hall : PackedVector2Array = astar.get_point_path(pos_from,pos_to)
		
		for t in hall:
			var pos : Vector3i = Vector3i(t.x,0,t.y)
			if gridMap.get_cell_item(pos) <0:
				gridMap.set_cell_item(pos,1)
		if _t%16 == 15: await  get_tree().create_timer(0).timeout
	
	
	
	
