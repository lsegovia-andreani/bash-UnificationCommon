#!/bin/sh

set -e

# Default settings
BUC=${ZSH:-~/.bash-UnificationCommon}
REPO=${REPO:-lsegovia-andreani/bash-UnificationCommon}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}


setup_unificationcommon() {
	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	echo "${BLUE}Cloning Bash Unification Common...${RESET}"

	if [ "$OSTYPE" = cygwin ] && git --version | grep -q msysgit; then
		error "Windows/MSYS Git is not supported on Cygwin"
		error "Make sure the Cygwin git package is installed and is first on the \$PATH"
		exit 1
	fi

	git clone -c core.eol=lf -c core.autocrlf=false \
		-c fsck.zeroPaddedFilemode=ignore \
		-c fetch.fsck.zeroPaddedFilemode=ignore \
		-c receive.fsck.zeroPaddedFilemode=ignore \
		--depth=1 --branch "$BRANCH" "$REMOTE" "$BUC" || {
		error "git clone of bash-UnificationCommon repo failed"
		exit 1
	}

	echo
}


configure() {
	echo
	echo "Starting builder..."
	echo
	echo "Checking dependencies..."
	echo
	DEPENDENCY=$BUC"/clients/oc/oc.exe"
	if [ ! -f "$DEPENDENCY" ]; then
	echo "Installing openshift client..."
	unzip "$PWD/clients/oc/oc.zip" -d "$BUC/clients/oc/"
	fi
	DEPENDENCY=$BUC"/clients/oc/kubectl.exe"
	if [ ! -f "$DEPENDENCY" ]; then
	echo "Installing openshift kubernetes client..."
	unzip "$BUC/clients/oc/kubectl.zip" -d "$BUC/clients/oc/"
	fi
	echo
	echo "Ready!"
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
        |____/ \___/ \____| ....is now installed!
	EOF
	printf "$RESET"

}

main "$@"