extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func __get_tile(xy):
	pass

func generate_maze_2():
	var width = 11
	var matrix = []
	for x in range(width):
		matrix.append([])
		for y in range(width):
			matrix[x].append('#')
	
	var froniter = []
	
	var random_tile = Vector2()
	
	random_tile.x = randi() % width
	random_tile.y = randi() % width
	
	if random_tile.x + d < width:
		froniter.append(Vector2(random_tile.x + d, random_tile.y))
	if random_tile.y + d < width:
		froniter.append(Vector2(random_tile.x, random_tile.y + d))
	if random_tile.x - d > 0:
		froniter.append(Vector2(random_tile.x - d, random_tile.y))
	if random_tile.y - d > 0:
		froniter.append(Vector2(random_tile.y, random_tile.y - d))
	var last = random_tile
	var op = last
	while(froniter.size() > 0):
		var next = randi() % froniter.size()
		var cu = froniter[next]
		froniter.remove(next)
		if op != null:
			last = op
			if matrix[op.x][op.y] == '#':
				if matrix[cu.x][cu.y] == '#':
					if matrix[op.x][op.y] == '#':
						matrix[cu.x][cu.y] = '.'
						matrix[op.x][op.y] = '.'
				if check_bound(Vector2(op.x + d, op.y), dimension):
					if matrix[op.x + d][op.y] == '#':
						froniter.append(Vector2(op.x + d, op.y))
						op = Vector2(op.x + 1, op.y)
				if check_bound(Vector2(op.x, op.y + d), dimension):
					if matrix[op.x][op.y + d] == '#':
						froniter.append(Vector2(op.x, op.y + d))
						op = Vector2(op.x, op.y + 1)
				if check_bound(Vector2(op.x - d, op.y), dimension):
					if matrix[op.x - d][op.y] == '#':
						froniter.append(Vector2(op.x - d, op.y))
						op = Vector2(op.x - 1, op.y)
				if check_bound(Vector2(op.x, op.y - d), dimension):
					if matrix[op.x][op.y - d] == '#':
						froniter.append(Vector2(op.x, op.y - d))
						op = Vector2(op.x, op.y - 1)
		for x in range(width):
			print(matrix[x])
		print(froniter)
		
	for x in range(width):
		print(matrix[x])

func opposite(current, parent):
	var diff_x = current.x - parent.x
	var diff_y = current.y - parent.y
	if diff_x != 0:
		if check_bound(Vector2(current.x + diff_x, current.y), dimension):
			return Vector2(current.x + diff_x, current.y)
	if diff_y != 0:
		if check_bound(Vector2(current.y, current.y + diff_y), dimension):
			return Vector2(current.x, current.y + diff_y)
	return null

func check_bound(xy, dim):
	if xy.x < dim.x and xy.x > 0:
		if xy.y < dim.y and xy.y > 0:
			return true


#		for x in range(width):
#			for y in range(width):
#				printraw(map[x][y])
#			printraw('\n')
#		printraw(frontiers)
#		printraw('\n')
#	
#	for x in range(width):
#		for y in range(width):
#			printraw(map[x][y])
#		printraw('\n')

	var set = []
	var queue = []
	var path = []
	set.append(root)
	queue.append(root)
	while not queue.empty():
		var current = queue.back()
		queue.pop_back()
		var adj = adjacent(current, graph)
		if not adj.empty():
			for node in adj:
				if not set.has(node):
					set.append(node)
					queue.push_back(node)
		if current == goal:
			set.invert()
			var last = goal
			path.append(goal)
			set.pop_front()
			for node in set:
				if last in adjacent(node, graph):
					last = node
					path.append(last)
			path.invert()
			print(path)


			if not counter.empty() and counter.size() < 3:
				if counter.back() < 3:
					s_id = (counter.back() + 1)
				else:
					s_id = 1
			else:
				s_id = 1
			print(s_id)
			counter.append(s_id)