extends Node

var lifes = 3

func take_damage(amount) -> void:
	print("Damage: ", amount)
	lifes -= amount
	print("Lifes: ", lifes)
	
	if lifes == 0:
		print("Bichinho moreu")
