# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

MACH="`uname -n`"
PIDS="`ps -ef | egrep ssh-agent | egrep $LOGNAME | egrep -v grep`"
if [ -z "$PIDS" ]
then
        eval `ssh-agent -s`
        echo "SSH_AGENT_PID=$SSH_AGENT_PID" >$HOME/.ssh/.mysshenv."$MACH"
        echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >>$HOME/.ssh/.mysshenv."$MACH"
        echo "export SSH_AGENT_PID SSH_AUTH_SOCK" >>$HOME/.ssh/.mysshenv."$MACH"
        ssh-add $HOME/.ssh/id_rsa
else
        echo "SSH-AGENT already running"
        . $HOME/.ssh/.mysshenv."$MACH"
fi


PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
