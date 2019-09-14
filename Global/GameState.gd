extends Node

enum mission_goals {Gravedigger = 1, Merchant = 2, Mayor = 3}
enum game_over {burn_by_sun, burn_by_lot, killed}
var daytime: float
var attention: float
var current_target
var killed_people = []
var witnesses = []