#!/bin/bash

configKubectlAutoSpell(){
  yum install -y bash-completion
  source /usr/share/bash-completion/bash_completion
  source <(kubectl completion bash)
}

configNStool(){
  ln -s /usr/local/src/k8sinstall/tools/kubens /usr/local/bin/ns
}
