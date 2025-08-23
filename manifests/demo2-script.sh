#!/bin/bash

function run_cmd() {
    echo "# $@"

    "$@"
    read
}

function header() {
	echo "========================================================================================="
	echo "    $@"
	echo "========================================================================================="
}

header "KIND Cluster"
run_cmd kubectl version

header "Show cluster-user-defined-network connecting red and yellow namespaces"
run_cmd cat cudns.yaml
run_cmd kubectl get clusteruserdefinednetwork -A -l purpose=oss-eu-2025-demo

header "Inspect the pods in all three networks"
# Save the complex command as a variable
NETWORK_CMD='printf "%-9s %-11s %-12s %-16s\n" "PODNAME" "NAMESPACE" "NETWORK" "POD_IP" && { oc get po -n blue -o=json; oc get po -n green -o=json; oc get po -n red -o=json; oc get po -n yellow -o=json; } | jq -r '\''
.items[] | 
select(.metadata.name | startswith("app-")) |
. as $pod |
(.metadata.annotations["k8s.ovn.org/pod-networks"] | fromjson | to_entries[]) |
select(.value.role == "primary") |
[$pod.metadata.name, $pod.metadata.namespace, (.key | split("/")[1]), (.value.ip_address | split("/")[0])] |
@tsv
'\'' | column -t'

# Run it using eval since the command contains special characters
run_cmd eval "$NETWORK_CMD"

header "Create VMs in colored-enterprise network"
run_cmd less vms.yaml
run_cmd kubectl apply -f vms.yaml

sleep 7

header "Get the VMs in red and yellow namespaces"
run_cmd kubectl get vmi -nred -owide
run_cmd kubectl get vmi -nyellow -owide

