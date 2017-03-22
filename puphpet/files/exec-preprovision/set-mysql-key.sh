
# Reading package lists... Done
# W: GPG error: http://repo.mysql.com/apt/ubuntu xenial InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 8C718D3B5072E1F5
# W: The repository 'http://repo.mysql.com/apt/ubuntu xenial InRelease' is not signed.
# N: Data from such a repository can't be authenticated and is therefore potentially dangerous to use.
# N: See apt-secure(8) manpage for repository creation and user configuration details.

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5

sudo apt-get update
