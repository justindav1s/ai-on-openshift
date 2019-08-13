#!/bin/bash

#export LD_LIBRARY_PATH=/usr/local/cuda-9.0:/usr/local/cuda-9.0/lib64:${LD_LIBRARY_PATH}

#echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

jupyter notebook \
	--allow-root \
	--ip=0.0.0.0 \
	--port=443 \
	--keyfile=/Users/jusdavis/acme/certs/datr.eu.key \
	--certfile=/Users/jusdavis/acme/certs/datr.eu.cer > jupyter.log &
