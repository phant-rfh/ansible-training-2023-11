#!/usr/bin/env python3

'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import subprocess
import sys
import argparse
import json
import re

class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.example_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory))

    # Example inventory for testing.
    def example_inventory(self):
        output = subprocess.getoutput('vagrant ssh-config')
        blocks = output.split('\n\n')

        group_block = {
            'vars': {
                'ansible_user': 'vagrant',
                'ansible_ssh_private_key_file':
                    '~/.vagrant.d/insecure_private_key',
                'ansible_python_interpreter':
                    '/usr/bin/python3',
                    }
        }
        inventory = {
            '_meta': {
                'hostvars': { }
            }
        }

        for b in blocks:
            h = re.search('Host (\S+)', b).group(1)
            ip = re.search('HostName (\S+)', b).group(1)
            p = re.search('Port (\d+)', b).group(1)

            group = ''
            host_is_db = re.search('db', h, re.IGNORECASE)
            if host_is_db:
                group = 'db'
            else:
                group = 'web'

            if not group in inventory:
                inventory[group] = group_block.copy()
                inventory[group]['hosts'] = [h]
            else:
                inventory[group]['hosts'].append(h)

            inventory['_meta']['hostvars'][h] = {
                    'ansible_host': ip,
                    'ansible_port': p
                }

        return inventory



    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
ExampleInventory()



#        return {
#            'group': {
#                'hosts': ['app1', 'app2', 'db1'],
#                'vars': {
#                    'ansible_user': 'vagrant',
#                    'ansible_ssh_private_key_file':
#                        '~/.vagrant.d/insecure_private_key',
#                    'ansible_python_interpreter':
#                        '/usr/bin/python3',
#                    'example_variable': 'value'
#                }
#            },
#            '_meta': {
#                'hostvars': {
#                    'app1': {
#                        'ansible_host': 'localhost',
#                        'ansible_port': '2222'
#                    },
#                    'app2': {
#                        'ansible_host': 'localhost',
#                        'ansible_port': '2200'
#                    },
#                    'db1': {
#                        'ansible_host': 'localhost',
#                        'ansible_port': '2201'
#                    }
#                }
#            }
#        }
