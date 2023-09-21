# Ansible

## Setup

- der Host auf dem der Ansible Hauptprozess läuft muss POSIX-compliant sein, also:
    - eine aktuelle Linux-Distribution [Ubuntu, Fedora, CentOS, Arch, ...]
    - ein aktueller Mac

### Ansible

#### Linux

- Installation von Ansible in einem python venv:
  ```
  python3 -m venv --copies ansible-venv
  cd ansible-venv
  source bin/activate
  pip3 install ansible
  ansible --version
  ```
#### Mac

- Installation via `homebrew`:
  `brew install ansible`

### Vagrant

- die Installation von Vagrant bedarf Administrator-Rechte
- Setup-Doku auf der [Vagrant Dokumentationsseite](https://developer.hashicorp.com/vagrant/docs/installation)

### SSH-Keys

- jeder Teilnehmer braucht auf seiner Trainings-Umgebung einen SSH-Key-Pair
- erstellbar, z.B. via:
  `ssh-keygen -t ed25519`
- der Public Key (z.B. `id_ed25519.pub`) muss auf allen Clients hinterlegt werden. Bei Vagrant geht das programmatisch
