# Redis Deployment on Kubernetes

## Overview
This repository contains the configuration for deploying Redis on the Nautilus Kubernetes cluster.

**Deployment Name:** `redis-deployment`

## Prerequisites
- kubectl configured to access the Kubernetes cluster
- Appropriate RBAC permissions to manage deployments

## Quick Start

### Check Deployment Status
```bash
kubectl get deployment redis-deployment
kubectl get pods -l app=redis
```

### View Deployment Details
```bash
kubectl describe deployment redis-deployment
kubectl describe pods -l app=redis
```

## Troubleshooting Guide

### Current Issue (Morning Incident)
The Redis deployment went down after configuration changes. Follow these steps to diagnose and fix:

#### Step 1: Check Pod Status
```bash
kubectl get pods -l app=redis
```

Look for pod states:
- **ImagePullBackOff**: Image name/tag is incorrect
- **CrashLoopBackOff**: Container is starting but crashing
- **Pending**: Resource constraints or scheduling issues
- **Error**: Configuration issues

#### Step 2: Check Events
```bash
kubectl describe deployment redis-deployment
kubectl describe pods -l app=redis
```

Look for error messages in the Even
