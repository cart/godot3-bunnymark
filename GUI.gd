extends Control

func _ready():
	$gdscript.connect("pressed", self, "switch_to_gd")
	$csharp.connect("pressed", self, "switch_to_cs")
	$cpp.connect("pressed", self, "switch_to_cpp")

func switch_to_cs():
	get_tree().change_scene("res://BenchmarkCS.tscn")
	
func switch_to_cpp():
	get_tree().change_scene("res://BenchmarkCPP.tscn")

func switch_to_gd():
	get_tree().change_scene("res://BenchmarkGD.tscn")