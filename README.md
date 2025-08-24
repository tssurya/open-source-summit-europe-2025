# Open Source Summit Europe 2025: VM-friendly Networking

This repository contains demonstration materials for the Open Source Summit Europe 2025 talk **"VM-friendly Networking"** ([Session Link](https://sched.co/25Vpx)).

## Overview

This demo showcases advanced Kubernetes networking capabilities using **User-Defined Networks (UDNs)** and **Cluster User-Defined Networks (CUDNs)** in OVN-Kubernetes, demonstrating how to achieve network isolation and seamless VM live migration in Kubernetes environments.

## Demo Recordings

- 📹 **[Demo 1: UDN Basics and Isolation](https://asciinema.org/a/735091)** - Learn the fundamentals of User-Defined Networks and network isolation
- 📹 **[Demo 2: Seamless Live Migration on Layer2 UDNs](https://asciinema.org/a/735109)** - See VM live migration in action with Layer2 networking

## Architecture

The demo environment consists of:

### Networks
- **Blue Network** (`blue-network`): Layer3 UDN with CIDR `103.103.0.0/16` 
- **Green Network** (`green-network`): Layer3 UDN with CIDR `203.203.0.0/16`
- **Colored Enterprise** (`colored-enterprise`): Layer2 CUDN with CIDR `192.168.0.0/16` connecting red and yellow namespaces

### Namespaces
- `blue` - Connected to blue-network (Layer3)
- `green` - Connected to green-network (Layer3)  
- `red` - Connected to colored-enterprise (Layer2)
- `yellow` - Connected to colored-enterprise (Layer2)

### Workloads
- **Pods**: StatefulSets running agnhost containers for network testing
- **VMs**: KubeVirt VirtualMachines with Fedora for live migration demonstrations

## Prerequisites

- KIND cluster with OVN-Kubernetes CNI
- KubeVirt installed for VM workloads
- kubectl configured for cluster access
- jq for JSON processing in demo scripts

## Quick Start

### Demo 1: UDN Basics and Network Isolation

1. **Setup the environment:**
   ```bash
   cd manifests/
   ./demo1-script.sh
   ```

2. **Key demonstrations:**
   - Create namespaces and UDN/CUDN networks
   - Deploy pods across different networks
   - Test network isolation between blue/green networks
   - Test connectivity within Layer2 colored-enterprise network
   - Verify external connectivity and Kubernetes API access

### Demo 2: VM Live Migration

1. **Run the migration demo:**
   ```bash
   cd manifests/
   ./demo2-script.sh
   ```

2. **Key demonstrations:**
   - Deploy VMs in Layer2 network
   - Establish network connections between VMs
   - Perform live migration while maintaining network connectivity
   - Verify seamless migration without connection drops

## Manual Setup

### 1. Create Namespaces
```bash
kubectl apply -f ns.yaml
```

### 2. Create Networks
```bash
# User-Defined Networks for blue and green
kubectl apply -f udns.yaml

# Cluster User-Defined Network for red and yellow  
kubectl apply -f cudns.yaml
```

### 3. Deploy Workloads
```bash
# Deploy pods
kubectl apply -f pods.yaml

# Deploy VMs (for migration demo)
kubectl apply -f vms.yaml
```

### 4. Verify Setup
```bash
# Check networks
kubectl get userdefinednetwork -A -l purpose=oss-eu-2025-demo
kubectl get clusteruserdefinednetwork -A -l purpose=oss-eu-2025-demo

# Check workloads
kubectl get pods -A -l purpose=oss-eu-2025-demo -owide
kubectl get vmi -A -l purpose=oss-eu-2025-vm-demo -owide
```

## Key Features Demonstrated

### Network Isolation
- **Layer3 UDNs**: Blue and green networks are completely isolated from each other
- **Layer2 CUDNs**: Red and yellow namespaces share a Layer2 broadcast domain
- **Default Network Access**: All pods maintain access to Kubernetes API and external internet

### Advanced Networking
- **Primary vs Infrastructure Networks**: Pods get multiple network interfaces
- **Custom IP Addressing**: Each UDN has its own IP address space
- **Cross-Namespace Connectivity**: CUDNs enable communication across namespace boundaries

### VM Live Migration
- **Seamless Migration**: VMs can migrate between nodes without losing network connectivity
- **Layer2 Benefits**: VMs maintain their IP addresses during migration
- **Zero Downtime**: Active network connections persist during migration

## Network Topology

```
┌─────────────────┐  ┌─────────────────┐
│  Blue Namespace │  │ Green Namespace │
│  (103.103.x.x)  │  │  (203.203.x.x)  │
│                 │  │                 │
│  ┌─────────┐    │  │    ┌─────────┐  │
│  │app-blue │    │  │    │app-green│  │
│  └─────────┘    │  │    └─────────┘  │
└─────────────────┘  └─────────────────┘
        │                        │
        └────── ISOLATED ────────┘

┌─────────────────────────────────────────┐
│      Colored Enterprise (Layer2)        │
│           (192.168.0.0/16)             │
│                                         │
│  ┌─────────────┐    ┌──────────────┐   │
│  │Red Namespace│    │Yellow Namespace│  │
│  │             │    │              │   │
│  │  ┌───────┐  │    │   ┌───────┐  │   │
│  │  │app-red│  │    │   │app-yel│  │   │
│  │  │  VM   │  │    │   │  VM   │  │   │
│  │  └───────┘  │    │   └───────┘  │   │
│  └─────────────┘    └──────────────┘   │
└─────────────────────────────────────────┘
```

## Commands Reference

See [`cheatsheet-commands.md`](manifests/cheatsheet-commands.md) for a comprehensive list of useful commands for exploring the demo environment.

## Cleanup

To tear down the demo environment:
```bash
cd manifests/
./tear-down.sh
```

## Contributing

This is a demonstration repository for the OSS Europe 2025 conference. Feel free to explore, modify, and extend the examples for your own learning and testing purposes.

## Resources

- [OVN-Kubernetes Documentation](https://github.com/ovn-org/ovn-kubernetes)
- [KubeVirt Documentation](https://kubevirt.io/user-guide/)
- [User-Defined Networks](https://ovn-kubernetes.io/features/user-defined-networks/user-defined-networks/)

---
*Demo created by [@tssurya](https://github.com/tssurya) for Open Source Summit Europe 2025*


