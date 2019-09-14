extends Node

enum mission_goals {GRAVEDIGGER = 1, MERCHANT = 2, MAYOR = 3}
enum game_over {BURNBYSUN, BURNBYLO, KILLED}
var daytime: float
var attention: float
var current_target
var killed_people = []
var witnesses = []
var is_game_over: bool
var game_over_state