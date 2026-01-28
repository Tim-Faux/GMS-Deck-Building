/// @desc								Deletes all objects in the layer this button is placed on and the
///											layer itself. NOTE the button has additional code to clean up
///											variables since the button itself is being deleted
if(button_clicked && is_top_layer(layer)) {
	button_clicked = false
	global.object_being_clicked = false
	find_and_delete_related_layers(layer)
}