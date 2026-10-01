# Shared zsh config for macOS and Linux/WSL. Sourced from ~/.zshrc.
# Secrets never live here: put them in ~/.secrets.zsh (not tracked).
[ -f "$HOME/.secrets.zsh" ] && source "$HOME/.secrets.zsh"

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

ulimit -n 65536 2>/dev/null

alias python='python3'
alias dev='ulimit -n 65536 && npm run dev'
alias dps="docker ps"
alias dkl="docker kill"

# Paperclip
alias paperclip='npx paperclipai'
alias paperclip-sync='cd ~/personal/paperclip && git fetch upstream && git merge upstream/master && git push origin master && cd -'
function paperclip-dev() {
  local cmd="${1:-status}"
  if [[ "$cmd" == "start" ]]; then
    echo "Starting Paperclip dev server..."
    (cd ~/personal/paperclip && nohup npx pnpm dev > /tmp/paperclip-dev.log 2>&1 &)
    echo "Paperclip starting in background. View logs with: paperclip-dev logs"
  elif [[ "$cmd" == "stop" ]]; then
    echo "Stopping Paperclip dev server..."
    (cd ~/personal/paperclip && npx pnpm dev:stop)
    (cd ~/personal/paperclip && ./scripts/kill-dev.sh >/dev/null 2>&1)
    echo "Stopped."
  elif [[ "$cmd" == "log" || "$cmd" == "logs" ]]; then
    tail -f /tmp/paperclip-dev.log
  else
    echo "Usage: paperclip-dev [start|stop|logs]"
    echo ""
    echo "Status of registered dev services:"
    (cd ~/personal/paperclip && npx pnpm dev:list)
  fi
}

# Kill all docker processes
function kdo() {
  ps ax|grep -i docker|egrep -iv 'grep|com.docker.vmnetd'|awk '{print $1}'|xargs kill
}

# Mac mini over Tailscale (ssh host alias `mini`). Shut it down before unplugging:
# cutting power corrupts the Docker databases. Relies on /etc/sudoers.d/shutdown there.
function mini-power() {
  local cmd="${1:-status}" sock="$SSH_AUTH_SOCK"
  # Reuse the agent from `ssh-agent -a ~/.ssh/agent.sock` if there is one; else ssh asks for the key passphrase.
  [ -S "$HOME/.ssh/agent.sock" ] && sock="$HOME/.ssh/agent.sock"
  if [[ "$cmd" == "off" ]]; then
    read -q "?Shut down the Mac mini? Blog and Postiz stay down until someone presses its power button. [y/N] " || { echo; return 1; }
    echo
    SSH_AUTH_SOCK="$sock" ssh mini 'sudo -n shutdown -h now'
    echo "Shutdown sent. Wait ~30s before unplugging."
  elif [[ "$cmd" == "reboot" ]]; then
    SSH_AUTH_SOCK="$sock" ssh mini 'sudo -n shutdown -r now'
    echo "Reboot sent. Services are back about a minute after boot."
  elif [[ "$cmd" == "status" ]]; then
    SSH_AUTH_SOCK="$sock" ssh -o ConnectTimeout=8 mini 'uptime' || echo "Mac mini unreachable (off, or Tailscale down)."
  else
    echo "Usage: mini-power [status|off|reboot]"
  fi
}
alias mini-off='mini-power off'

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
