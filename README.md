# Ansible

## Setup

- der Host auf dem der Ansible Hauptprozess läuft muss POSIX-compliant sein, also:
    - eine aktuelle Linux-Distribution [Ubuntu, Fedora, CentOS, Arch, ...]
    - ein aktueller Mac

### Ansible

- Installation von Ansible in einem python venv:
  ```bash
  python3 -m venv --copies ansible-venv
  cd ansible-venv
  source bin/activate
  pip3 install ansible
  ansible --version
  ```

- für Windows-Management, ist `pywinrm` notwendig 
  ```bash
  pip3 install pywinrm
  ```

### Vagrant

- die Installation von Vagrant bedarf Administrator-Rechte
- Setup-Doku auf der [Vagrant Dokumentationsseite](https://developer.hashicorp.com/vagrant/docs/installation)

### SSH-Keys

- jeder Teilnehmer braucht auf seiner Trainings-Umgebung einen SSH-Key-Pair
- erstellbar, z.B. via:
  `ssh-keygen -t ed25519`
- der Public Key (z.B. `id_ed25519.pub`) muss auf allen Clients hinterlegt werden. Bei Vagrant geht das programmatisch

## Windows-Vars
```ini
[windows:vars]
ansible_user       = localadmin
ansible_password   = secret
ansible_connection = winrm
ansible_winrm_server_cert_validation = ignore # To change this, the Control Node needs to have access to the CA that 
                                              # the Windows host used to sign its own certificate
```

## Common WinRM Issues

- https://docs.ansible.com/ansible/latest/os_guide/windows_setup.html#id10
