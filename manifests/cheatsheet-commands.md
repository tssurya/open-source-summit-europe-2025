# Introduction

* kubectl version
* kubectl get nodes -owide
* kubectl get pods -n ovn-kubernetes -owide

# Pods with UDNs and CUDNs

* kubectl apply -f ns.yaml
* kubectl get ns -owide -l k8s.ovn.org/primary-user-defined-network
* cat udns.yaml
* kubectl apply -f udns.yaml
* kubectl get userdefinednetwork -A -l purpose=oss-eu-2025-demo
* kubectl get userdefinednetwork -n blue -oyaml
* kubectl get userdefinednetwork -n green -oyaml
* cat cudns.yaml
* kubectl apply -f cudns.yaml
* kubectl get clusteruserdefinednetwork -A -l purpose=oss-eu-2025-demo
* kubectl get clusteruserdefinednetwork colored-enterprise -oyaml
* kubectl apply -f pods.yaml
* kubectl get pods -A -l purpose=oss-eu-2025-demo -owide
* kubectl get pod -n blue app-blue-0 -oyaml
* kubectl exec -it -n blue app-blue-0 -- ip a
* kubectl exec -it -n blue app-blue-0 -- ip r
* kubectl exec -it -n blue app-blue-0 -- ping -w 3 -c 3 ${PRIMARY POD IP OF APP-BLUE-1}
* kubectl get pod -n green app-green-0 -oyaml
* kubectl exec -it -n green app-green-0 -- ip a
* kubectl exec -it -n green app-green-0 -- ip r
* kubectl exec -it -n green app-green-0 -- ping -w 3 -c 3 ${PRIMARY POD IP OF APP-GREEN-1}

# Testing Network Isolation

* kubectl exec -it -n blue app-blue-0 -- ping -w 3 -c 3 ${PRIMARY POD IP OF APP-GREEN-0}
* kubectl get pod -n yellow app-yellow-0 -oyaml
* kubectl exec -it -n red app-red-0 -c agnhost-container-8080 -- ping -w 3 -c 3 ${PRIMARY POD IP OF APP-YELLOW-0}

# Services (Ingress) with UDN Pods

* kubectl apply -f services.yaml
* kubectl get svc -A -l purpose=oss-eu-2025-demo
* kubectl get endpointslices -n blue
* kubectl get endpointslices -n green
* kubectl get svc -n blue
* kubectl exec -it -n blue app-blue-0 -- curl --connect-timeout 3 http://${BLUESVCIP}:80/hostname && echo
* kubectl get svc -n green
* kubectl exec -it -n green app-green-0 -- curl --connect-timeout 3 http://${GREENSVCIP}:80/hostname && echo
* kubectl exec -it -n blue app-blue-0 -- curl --connect-timeout 3 http://${GREENSVCIP}:80/hostname && echo
* kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
* curl --connect-timeout 3 http://${NODEIP}:${BLUE-SVC-NODEPORT}/hostname && echo
* curl --connect-timeout 3 http://${NODEIP}:${GREEN-SVC-NODEPORT}/hostname && echo
* kubectl exec -it -n blue app-blue-0 -- curl --connect-timeout 4 kubernetes.default.svc.cluster.local:443 && echo
* kubectl exec -it -n green app-green-0 -- curl --connect-timeout 4 kubernetes.default.svc.cluster.local:443 && echo

# Egress with UDN Pods

* kubectl exec -it -n blue app-blue-0 -- ping -w 3 -c 3 8.8.8.8
* kubectl exec -it -n green app-green-0 -- ping -w 3 -c 3 google.com

# VM Live Migration
kubectl get vmi -nred -owide
kubectl get vmi -nyellow -owide

virtctl console -nred red
ip a
ip r
ping 192.168.0.8
ping www.google.com
iperf3 -c 192.168.x.x -p9000 -t3600

virtctl console -nyellow yellow
iperf3 -s -p9000 -1

kubectl get pods -A -l purpose=oss-eu-2025-vm-demo -owide -w

virtctl migrate -nyellow yellow

virtctl console -nyellow yellow
ip a

