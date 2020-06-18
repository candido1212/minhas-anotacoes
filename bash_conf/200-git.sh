# Alguns destes comando, poderiam ser usado como alias do git
# Recomendacao:
# sudo apt-get install git-extras
[[ -f /usr/bin/git ]] || { return ; }

# usado para o prompt PS1
_gitParseBranch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

# mostra branch atual
#export PS1="\n\w $(_gitParseBranch)\n${CCyan}\u@\h${NC} >${NC}"
export PS1="$CCyan\u@\h>\[\033[32m\]\w$BIYellow\$(_gitParseBranch)\[\033[00m\]>"
#export PS1="\$(_gitParseBranch)\n\u@\h \w >"
#export PS1="\u@\h\n\w\$(_gitParseBranch)>"


ct_gitPS1() {
	export PS1="$CCyan\u@\h>\[\033[32m\]\w$BIYellow\$(_gitParseBranch)\[\033[00m\]>"
}
## Config ##
ct_git_config_ignore_chmod()
{
	echo_and_run git config --global core.fileMode false
}
ct_git_config_auto_linefeed() {
	echo_and_run git config --global core.autocrlf true
}

# https://www.jamescoyle.net/how-to/1891-git-ssl-certificate-problem-caused-by-self-signed-certificates
ct_git_config_ignoreSSL() {
	echo_and_run git config --global http.sslVerify false
}

ct_git_config_default_global() {
	# Allow Extended Regular Expressions
	git config --global grep.extendRegexp true
	# Always Include Line Numbers
	git config --global grep.lineNumber true

	# Last commit
	git config --global alias.last 'log -1 HEAD'
	
	git config --global alias.co checkout
	git config --global alias.br branch
	git config --global alias.ci commit
	git config --global alias.st status	
}
ct_git_config_listarConfiguracao() {
	echo_and_run git config --list
}

## Atualiza o repositorio forked com o original
ct_gitMantemForkedAtualizado() {
	local REMOTO_ORIGNAL_GIT_REPOSITORY="$1"
	git remote add upstream "$REMOTO_ORIGNAL_GIT_REPOSITORY"
	git fetch upstream

	echo_and_run git pull upstream master
}


ct_git_reset_toCommit() {
	HELPTXT="Retorne para o commit, apagando todos os outros posteriores 'git log'\n\n${FUNCNAME[0]} <commit>"
	ct_help $1

	echo_and_run git reset --hard $hashDoCommit
	echo_and_run git push origin master --force
}

# https://stackoverflow.com/questions/4858047/the-following-untracked-working-tree-files-would-be-overwritten-by-checkout
# Limpar todas alterações do commit atual.
ct_git_clean() {
	echo_and_run git clean  -d  -fx
}

### LOCAL ####
ct_gitResetCopiaBranchParaOutro()
{
	HELPTXT="Copia a branch <param1> para a branch corrente\n\n${FUNCNAME[0]} <nomeDaBranch>"
	ct_help $1

	nomeDaBranchRemoto=$1
	nomeDaBranchDestino=$(git rev-parse --abbrev-ref HEAD)
	#git reset -- hard $nomeDaBranchOrigem
}

ct_git_commit_desfazUltimo() {
	HELPTXT="Desfaz o último commit"
	ct_help $1
	echo_and_run git reset HEAD~
}

ct_git_clone_ultimoCommit() {
	echo_and_run git clone --depth=1 "$1"
}


ct_git_branch_listaTodas() {
	echo_and_run git branch -vv
}

ct_git_syncRemoteBranchToLocal() {
	HELPTXT="Remove todas as branchs local, que foram deletadas no remoto \n Obs: Branchs locais que nunca foram para o remoto, não serão removidas \n http://erikaybar.name/git-deleting-old-local-branches/"
	ct_help $1

	git remote prune origin  
	git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}



ct_git_syncRemoteWithBranch2LocalAll() {
	HELPTXT="Remove todas as branchs locais e sincroniza com as do remoto, deixando todas as branchs remota com as locais"
	ct_help $1

	echo_and_run git branch --merged master | grep -v '^[ *]*master$' | xargs git branch -d
	echo_and_run git branch -a
}

ct_git_stash_salvar() {
	local NOME="$1"
	echo "Salvo todos itens modificados ou criados"
	echo_and_run git stash push -m "$NOME"
}
ct_git_stash_restauraUltimo() {
	echo "Recuperado último stash gravado"
	echo_and_run git stash apply
}


ct_git_searchText_inAllBranches() {
	local STRING_SEARCH="$1"
	echo_and_run git grep "$1" $(git rev-list --all)
}



#### REMOTO ####
ct_gitRemotoDeleteBranch()
{
	HELPTXT="Apaga uma branch remota\n\n${FUNCNAME[0]} <nomeDaBranch>"
	ct_help $1

	nomeDaBranchRemoto=$1
	echo_and_run git push origin --delete $nomeDaBranchRemoto
}


ct_git_branchDeleteRemote() {
	local REMOTE_BRANCH_NAME="$1"
	echo_and_run git push origin --delete "$REMOTE_BRANCH_NAME"
}

ct_git_branchDeleteLocal() {
	local LOCAL_BRANCH_NAME="$1"
	echo_and_run git branch --delete "$LOCAL_BRANCH_NAME"
}

ct_git_ignoreFileTemplate() {
	echo "
# Develop #
.classpath
.project
target

# Compiled source #
###################
*.com
*.class
*.dll
*.exe
*.o
*.so

# Temporary files #
###################
*.swp
*.swo
*~

# Packages #
############
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
######################
*.log
*.sql
*.sqlite

# OS generated files #
######################
.DS_Store*
ehthumbs.db
Icon?
Thumbs.db
" > .gitignore
}


ct_git_listAllUntrackedFiles() {
	echo_and_run git ls-files . --exclude-standard --others
}

ct_git_listAllIgnoredFiles() {
	echo_and_run git ls-files . --ignored --exclude-standard --others
}