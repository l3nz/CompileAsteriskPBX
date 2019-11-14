# Janus on CentOS 7

Compiles and installs Janus on a clean CentOS 7 system.

* You can specify the version (or the tags) for any dependency
* Compiles FFmpeg for post-processing and installs Lua modules
* Uses a recent `libnice` and version  2 of `libsrtp`

Usage:

	wget 
	chmod a+x 
	./...

After a while... you can start Janus:

	cd /opt/janus
	./bin/janus











## Configuration

		Compiler:                  gcc
		libsrtp version:           2.x
		SSL/crypto library:        OpenSSL
		DTLS set-timeout:          not available
		Mutex implementation:      GMutex (native futex on Linux)
		DataChannels support:      yes
		Recordings post-processor: yes
		TURN REST API client:      yes
		Doxygen documentation:     no
		Transports:
		    REST (HTTP/HTTPS):     yes
		    WebSockets:            yes
		    RabbitMQ:              no
		    MQTT:                  no
		    Unix Sockets:          yes
		    Nanomsg:               no
		Plugins:
		    Echo Test:             yes
		    Streaming:             yes
		    Video Call:            yes
		    SIP Gateway (Sofia):   yes
		    SIP Gateway (libre):   no
		    NoSIP (RTP Bridge):    yes
		    Audio Bridge:          yes
		    Video Room:            yes
		    Voice Mail:            yes
		    Record&Play:           yes
		    Text Room:             yes
		    Lua Interpreter:       yes
		    Duktape Interpreter:   yes
		Event handlers:
		    Sample event handler:  yes
		    WebSocket ev. handler: yes
		    RabbitMQ event handler:no
		    MQTT event handler:    no
		    Nanomsg event handler: no
		JavaScript modules:        yes
		    Using npm:             /usr/bin/npm
		    ES syntax:             yes
		    IIFE syntax:           yes
		    UMD syntax:            yes
		    CommonJS syntax:       yes
