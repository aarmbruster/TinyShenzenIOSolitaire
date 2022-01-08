class_name CardColors

static func get_color(index:int):
	var colors = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
	return colors[index]

static func white():
	return Color.white

static func black():
	return Color.black

static func green():
	return Color(0.06, 0.36, 0.16, 1.0)

static func red():
	return Color(1.7, 20.0, 0.078 , 1.0)
