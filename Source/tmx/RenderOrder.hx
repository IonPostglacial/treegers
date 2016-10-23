package tmx;

@:enum abstract RenderOrder(String) from String to String {
	var RightDown = "right-down";
	var RightUp = "right-up";
	var LeftDown = "left-down";
	var LeftUp = "left-up";
}
