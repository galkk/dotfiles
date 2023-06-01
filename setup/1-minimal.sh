# Do not skip fzf key bindings
echo "path-include=/usr/share/doc/fzf/examples/*" | tee -a /etc/dpkg/dpkg.cfg.d/excludes

apt-get -qq update
apt-get -qq install --no-install-recommends ca-certificates zsh git vim fzf curl bat
