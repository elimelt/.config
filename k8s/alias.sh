#!/bin/bash
# kubectl + fzf interactive aliases
# Source this in your .zshrc or .bashrc: source /path/to/kubectl-fzf-aliases.sh
#
# Usage with custom kubectl command:
#   source kubectl-fzf-aliases.sh --ctlcmd /path/to/custom/kubectl

# Parse --ctlcmd option
KUBECTL=${KUBECTL:-kubectl}

while [[ $# -gt 0 ]]; do
  case $1 in
    --ctlcmd)
      KUBECTL="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# ============================================================================
# POD SELECTION & ACTIONS
# ============================================================================

# Select and exec into a pod
kexec() {
  local pod ns_args
  ns_args="--all-namespaces"
  
  pod=$($KUBECTL get pods $ns_args -o name | sed 's|pod/||' | fzf --preview "$KUBECTL describe pod {}" --preview-window=right:50%)
  [ -n "$pod" ] && $KUBECTL exec -it "$pod" -- /bin/bash
}

# Select and view logs from a pod
klogs() {
  local pod ns_args
  ns_args="--all-namespaces"
  
  pod=$($KUBECTL get pods $ns_args -o name | sed 's|pod/||' | fzf --preview "$KUBECTL logs --tail=50 {}")
  [ -n "$pod" ] && $KUBECTL logs -f "$pod"
}

# Select and describe a pod
kdesc() {
  local pod ns_args
  ns_args="--all-namespaces"
  
  pod=$($KUBECTL get pods $ns_args -o name | sed 's|pod/||' | fzf --preview "$KUBECTL describe pod {}" --preview-window=right:50%)
  [ -n "$pod" ] && $KUBECTL describe pod "$pod"
}

# Select and delete a pod
kdel() {
  local pods ns_args
  ns_args="--all-namespaces"
  
  pods=$($KUBECTL get pods $ns_args -o name | sed 's|pod/||' | fzf -m --preview "$KUBECTL describe pod {}")
  if [ -n "$pods" ]; then
    echo "$pods" | xargs -I {} $KUBECTL delete pod {}
  fi
}

# ============================================================================
# DEPLOYMENT & STATEFULSET ACTIONS
# ============================================================================

# Select and view deployment/statefulset logs
kdeplogs() {
  local deployment
  deployment=$($KUBECTL get deployments,statefulsets --all-namespaces -o name | sed 's|deployment.apps/\|statefulset.apps/||' | fzf --preview "$KUBECTL describe {}")
  if [ -n "$deployment" ]; then
    local pod
    pod=$($KUBECTL get pods --all-namespaces -l app="$deployment" -o name | sed 's|pod/||' | head -1)
    [ -n "$pod" ] && $KUBECTL logs -f "$pod"
  fi
}

# Restart a deployment
krestart() {
  local deployment
  deployment=$($KUBECTL get deployments --all-namespaces -o name | sed 's|deployment.apps/||' | fzf --preview "$KUBECTL describe deployment {}")
  [ -n "$deployment" ] && $KUBECTL rollout restart deployment/"$deployment"
}

# ============================================================================
# PORT FORWARDING
# ============================================================================

# Port forward to a pod (select interactively)
kpf() {
  local pod local_port remote_port
  pod=$($KUBECTL get pods --all-namespaces -o name | sed 's|pod/||' | fzf --preview "$KUBECTL describe pod {}")
  if [ -n "$pod" ]; then
    read -p "Local port: " local_port
    read -p "Remote port (default 8080): " remote_port
    remote_port=${remote_port:-8080}
    echo "Port forwarding $pod: $local_port:$remote_port"
    $KUBECTL port-forward pod/"$pod" "$local_port:$remote_port"
  fi
}

# ============================================================================
# CONTEXT & NAMESPACE
# ============================================================================

# Switch namespace (requires kubectx installed, or use built-in)
kns() {
  local namespace
  namespace=$($KUBECTL get namespaces -o name | sed 's|namespace/||' | fzf --preview "$KUBECTL get pods -n {}")
  [ -n "$namespace" ] && $KUBECTL config set-context --current --namespace="$namespace"
}

# Switch context (if you have multiple clusters)
kctx() {
  local context
  context=$($KUBECTL config get-contexts -o name | fzf)
  [ -n "$context" ] && $KUBECTL config use-context "$context"
}

# ============================================================================
# RESOURCE BROWSING
# ============================================================================

# Browse services interactively
ksvc() {
  local svc
  svc=$($KUBECTL get svc --all-namespaces -o name | sed 's|service/||' | fzf --preview "$KUBECTL describe svc {}")
  [ -n "$svc" ] && $KUBECTL describe svc "$svc"
}

# Browse configmaps interactively
kcm() {
  local cm
  cm=$($KUBECTL get configmaps --all-namespaces -o name | sed 's|configmap/||' | fzf --preview "$KUBECTL describe configmap {}")
  [ -n "$cm" ] && $KUBECTL describe configmap "$cm"
}

# Browse secrets interactively
ksec() {
  local secret
  secret=$($KUBECTL get secrets --all-namespaces -o name | sed 's|secret/||' | fzf --preview "$KUBECTL describe secret {}")
  [ -n "$secret" ] && $KUBECTL describe secret "$secret"
}

# ============================================================================
# QUICK INFO
# ============================================================================

# Get all resources in a namespace with fzf selection
kres() {
  $KUBECTL api-resources --verbs=list --namespaced=true -o name | fzf -m | xargs -I {} $KUBECTL get {} --all-namespaces
}

# ============================================================================
# DIRECT SHORTCUTS
# ============================================================================

# Quick aliases for common commands
alias kgp="$KUBECTL get pods"
alias kgpa="$KUBECTL get pods --all-namespaces"
alias kgs="$KUBECTL get svc"
alias kgd="$KUBECTL get deploy"
alias kgn="$KUBECTL get nodes"
alias kctx_list="$KUBECTL config get-contexts"
alias kns_list="$KUBECTL get namespaces"

# Multi-select delete (select multiple pods/resources with Ctrl+Space)
kdel_multi() {
  local resources
  resources=$($KUBECTL get pods --all-namespaces -o name | sed 's|pod/||' | fzf -m --preview "$KUBECTL describe pod {}")
  if [ -n "$resources" ]; then
    echo "$resources" | xargs -I {} $KUBECTL delete pod {}
  fi
}

# ============================================================================
# HELP & INFO
# ============================================================================

khelp() {
  echo "Usage examples:"
  echo "  kexec              - Select and exec into a pod"
  echo "  klogs              - Select a pod and view logs"
  echo "  kdesc              - Describe a pod"
  echo "  kdel               - Delete a pod"
  echo "  kpf                - Port forward to a pod"
  echo "  kns                - Switch namespace"
  echo "  kctx               - Switch context"
  echo "  ksvc               - Browse services"
  echo "  kusage             - Show resource usage"
}

# Show resource usage
kusage() {
  echo "=== Node Usage ==="
  $KUBECTL top nodes
  echo ""
  echo "=== Pod Usage ==="
  $KUBECTL top pods --all-namespaces | head -20
}

# ============================================================================
# NOTES
# ============================================================================
# 
# All commands search across all namespaces by default.
#
# Customize KUBECTL variable if using a custom kubectl wrapper:
#   export KUBECTL=/path/to/your/custom/kubectl
#   source this script
#
# Or pass it as an argument:
#   source kubectl-fzf-aliases.sh --ctlcmd /path/to/custom/kubectl
