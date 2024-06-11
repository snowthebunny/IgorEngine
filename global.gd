extends Node

var guns = ["shotgun", "gun", "shovel"]
var ammo = [10, 10, -1]
var player:CharacterBody3D = null
var current_gun_index = 0
var current_gun = guns[current_gun_index]
