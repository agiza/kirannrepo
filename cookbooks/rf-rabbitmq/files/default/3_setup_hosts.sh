#!/bin/bash

#Run this script from the machine on which you are installing

#update /etc/hosts

#for qa
sudo grep -q '10.0.10.142 rfng-realsearch-dev4' /etc/hosts || sudo echo "10.0.10.142 rfng-realsearch-dev4" >> /etc/hosts
sudo grep -q '10.0.10.154 rfng-realsearch-dev5' /etc/hosts || sudo echo "10.0.10.154 rfng-realsearch-dev5" >> /etc/hosts
sudo grep -q '10.0.0.200 rfrealsearch-qa' /etc/hosts || sudo echo "10.0.0.200 rfrealsearch-qa" >> /etc/hosts

#for dev
sudo grep -q '10.0.0.6 rfrealsearch-dev' /etc/hosts || sudo echo "10.0.0.6 rfrealsearch-dev" >> /etc/hosts
sudo grep -q '10.0.0.179 rfrealsearch-dev2' /etc/hosts || sudo echo "10.0.0.179 rfrealsearch-dev2" >> /etc/hosts
sudo grep -q '10.0.10.183 rfng-realsearch-dev3' /etc/hosts || sudo echo "10.0.10.183 rfng-realsearch-dev3" >> /etc/hosts
