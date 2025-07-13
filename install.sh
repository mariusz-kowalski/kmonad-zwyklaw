install() {
	name="$1"
	sudo cp $name.kbd /etc/kmonad/
	sudo systemctl enable kmonad@$name.service
	sudo systemctl restart kmonad@$name.service
}


install precision5520
install k400
install ergodox-anticross