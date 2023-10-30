#This Script Creates a vpc with 3 Subnets in 3 different regions and deploy 3 fl.micro
# ubuntu servers
vpc="dev-vpc"
project="internalprojects-403414"

#vpc Creation
gcloud compute networks create ${vpc} --project=${project} --description=${vpc} --subnet-mode=custom --mtu=1500 --bgp-routing-mode=regional

#subnet creation
gcloud compute networks subnets create ${vpc}-subnet-1 \
--project=${project} \
--description="${vpc}-subnet-1" \
--range=10.1.1.0/24 \
--network=${vpc} \
--region=us-east1

gcloud compute networks subnets create ${vpc}-subnet-2 \
--project=${project} \
--description="${vpc}-subnet-2" \
--range=172.16.1.0/24  \
--network=${vpc} \
--region=us-east1

gcloud compute networks subnets create ${vpc}-subnet-3 \
--project=${project} \
--description="${vpc}-subnet-3" \
--range=192.168.1.0/24   \
--network=${vpc} \
--region=us-east1



#Firewa11 Rules Creation
gcloud compute firewall-rules create ${vpc}-allow-ingress \
--project=${project} \
--network=projects/${project}/global/networks/${vpc} \
--description="Allows incoming connections from any source to any instance on the network using custom protocols." \
--direction=INGRESS \
--priority=100 \
--action=ALLOW \
--rules=all

gcloud compute firewall-rules create ${vpc}-allow-egress \
--project=${project} \
--network=projects/${project}/global/networks/${vpc} \
--description="Allows outgoing connections from any source to any instance on the network using custom protocols." \
--direction=EGRESS \
--priority=100 \
--action=ALLOW \
--rules=all


#lnstance Creation
gcloud compute instances create ${vpc}-instance-1 \
--project=${project} \
--zone=us-east1-b \
--machine-type=f1-micro \
--network-interface=network-tier=PREMIUM,subnet=${vpc}-subnet-1 \
--maintenance-policy=MIGRATE \
--no-service-account \
--no-scopes \
--create-disk=auto-delete=yes,boot=yes,device-name=${vpc}-instance-1,image-family=ubuntu-2004-lts,image-project=ubuntu-os-cloud,size=10,type=pd-balanced \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any