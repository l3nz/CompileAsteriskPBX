# CompileAsteriskPBX

Download and compile a modern Asterisk PBX for Centos7.

As Centos 7 does not ship with a working Asterisk version as an RPM package
(and even if it did it would likely be outdated), you sometimes have the need to
install Asterisk automagically.

You can run:

	wget -O- https://raw.githubusercontent.com/l3nz/CompileAsteriskPBX/master/centos7/compileAsterisk-13_9_1.sh | bash

and your Astersisk 13.9.1 will be downloaded and installed. All developement tools and packages will
be downloaded as needed and then removed by the end of the script. We install Asterisk with its samples,
so you have a valid configuration to get started (feel free to delete/replace the ones you don't need).

This also comes in handy if you:

* Are building a docker image. By running a single script, all changes go to a single layer.
* Are installing a box using some automated tool, e.g. ansible.

Based upon https://github.com/leifmadsen/certified-asterisk . You may also
want to check https://github.com/asterisk/asterisk/tree/master/contrib/docker .

Patches for different versions of Asterisk and different OS are welcome.

## Example: Ansible

Using this in Ansible is easy-peasy:

    - name: download executable script
      get_url: url=https://raw.githubusercontent.com/l3nz/CompileAsteriskPBX/master/centos7/compileAsterisk-13_9_1.sh dest=/root/buildAsterisk mode=0700
      
    - name: download and compile Asterisk (if not present)
      shell: /root/buildAsterisk
      args:
        creates: /usr/sbin/asterisk

    - name: Start Asterisk 
      shell: /usr/sbin/asterisk
      args:
        creates: /var/run/asterisk/asterisk.ctl



