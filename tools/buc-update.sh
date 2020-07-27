#!/bin/sh
BUC=${ZSH:-~/.bash-UnificationCommon}

set -e

update() {

    cd $BUC
    git  reset --hard
    git  pull origin master

}

main() {
	# Run as unattended if stdin is closed
	setup_unificationcommon
	echo
	configure

	printf "$GREEN"
	cat <<-'EOF'
         ____  _   _  ____ 
        | __ )| | | |/ ___|
        |  _ \| | | | |    
        | |_) | |_| | |___ 
        |____/ \___/ \____| ....is now updated!
	EOF
	printf "$RESET"

}

main "$@"