#!/bin/bash

eval $(gpg-agent --daemon --write-env-file "/root/.gpg-agent-info")

if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
fi

GPG_TTY=$(tty)
export GPG_TTY

/bin/bash
