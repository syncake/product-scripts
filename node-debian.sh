#!/bin/bash

node_mainversion="14"

apt update -y
apt install npm -y 
npm i -g n
n $(n lsr 14 | head -2 | tail -1)
npm i -g yarn 
apt remove nodejs npm -y --purge
