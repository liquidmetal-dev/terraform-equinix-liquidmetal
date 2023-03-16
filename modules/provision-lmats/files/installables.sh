#!/bin/bash -ex

KIND_VERSION=0.14.0
CLUSTERCTL_VERSION=1.1.5
K9S_VERSION=0.25.21
GO_VERSION=1.19.3

install_go() {
    wget "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
    go version
}

install_kind() {
    wget "https://github.com/kubernetes-sigs/kind/releases/download/v$KIND_VERSION/kind-linux-amd64"
    chmod +x ./kind-linux-amd64
    mv ./kind-linux-amd64 /usr/local/bin/kind
    kind --version
}

install_docker() {
    apt update
    apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io
    docker version
}

install_clusterctl() {
    curl -L "https://github.com/kubernetes-sigs/cluster-api/releases/download/v$CLUSTERCTL_VERSION/clusterctl-linux-amd64" -o clusterctl
    chmod +x ./clusterctl
    mv ./clusterctl /usr/local/bin/clusterctl
    clusterctl version
}

install_kubectl() {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    mv ./kubectl /usr/local/bin
    kubectl version
}

install_kustomize() {
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    mv ./kustomize /usr/local/bin
}

install_k9s() {
    curl -sL "https://github.com/derailed/k9s/releases/download/v$K9S_VERSION/k9s_Linux_x86_64.tar.gz" | tar xz -C /usr/local/bin
}

install_apt_pkgs() {
    apt update
    apt install -y \
        make \
        gcc
}

mkdir -p "$HOME/installables"
pushd "$HOME/installables"

install_go || true
install_kind || true
if ! which docker >/dev/null 2>/dev/null; then
    install_docker || true
fi
install_clusterctl || true
install_kubectl || true
install_kustomize || true
install_k9s || true
install_apt_pkgs || true

popd
rm -rf "$HOME/installables"
