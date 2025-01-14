# Kubernetes Helm Chart Troubleshooting

## Overview
This document describes the troubleshootaing steps I followed while installing and configuring a Kubernetes application using Helm and Terraform. The application was deployed to the `rc-homework` namespace, and several errors were encountered during the installation process, which were resolved step-by-step.

## Terraform Namespace Creation
- The first step was to create the Kubernetes namespace `rc-homework` using Terraform. This was completed successfully without any issues.

## Helm Chart Errors and Fixes

### Error 1: Namespace Not Found
- **Error**: 
  ```
  INSTALLATION FAILED: 2 errors occurred:
    * namespaces "homework" not found
    * namespaces "homework" not found
  ```
- **Cause**: The Helm chart was referencing a namespace named `homework`, but the correct namespace (`rc-homework`) had been created using Terraform.
- **Fix**: 
  - Updated the namespace references in `templates/service.yaml` and `templates/deployment.yaml` to `rc-homework` to match the Terraform configuration.

### Error 2: Invalid Service Configuration
- **Error**:
  ```
  UPGRADE FAILED: failed to create resource: Service "rc-rc-homework" is invalid: 
  [spec.ports[0].port: Invalid value: 0: must be between 1 and 65535, inclusive, 
  spec.ports[0].protocol: Unsupported value: "tcp": supported values: "SCTP", "TCP", "UDP"]
  ```
- **Cause**: The service configuration was incorrect with an invalid port value and an unsupported protocol.
- **Fix**:
  - In `values.yaml`, changed the service protocol from `tcp` to `TCP` to ensure compatibility.
  - In `templates/service.yaml`, changed the port from `{{ .Values.service.sourcePort }}` to `{{ .Values.service.port }}` to correctly reference the desired port.

### Error 3: Invalid Deployment Resource Requests
- **Error**:
  ```
  UPGRADE FAILED: failed to create resource: Deployment.apps "rc-rc-homework" is invalid: 
  [spec.template.spec.containers[0].resources.requests: Invalid value: "500m": 
  must be less than or equal to cpu limit of 250m, spec.template.spec.containers[0].resources.requests: 
  Invalid value: "512Mi": must be less than or equal to memory limit of 256Mi]
  ```
- **Cause**: The resource requests for CPU and memory exceeded the defined limits.
- **Fix**:
  - In `values.yaml`, reduced the resource requests for memory and CPU to match the limits, as the Nginx container is lightweight and doesn't require high resource allocations.

### Error 4: Image Pull Error (ErrImagePull)
- **Error**:
  ```
  $ kubectl get pods -n rc-homework                             
  NAME                              READY   STATUS         RESTARTS   AGE
  rc-rc-homework-854bb87b48-8stl7   0/1     ErrImagePull   0          56s
  
  $ kubectl describe pod rc-rc-homework-854bb87b48-8stl7 -n rc-homework
  . . .
  Failed to pull image "nginx:1.21-latest": Error response from daemon: manifest for nginx:1.21-latest not found: manifest unknown: manifest unknown
  . . .
  ```
- **Cause**: The specified image tag `nginx:1.21-latest` was invalid or unavailable.
- **Fix**:
  - Changed the image tag from `1.21-latest` to `latest`, which is a valid and available tag for the Nginx image.
  - Ideally, I would confirm with the deploying team which application tag is correct, but continued with the `latest` tag to proceed with the task.

## Final Issues and Fixes

### Error: Connection Refused on Port Forwarding
- **Error**:
  ```
  kubectl port-forward svc/rc-rc-homework 8080:80 -n rc-homework
  Forwarding from 127.0.0.1:8080 -> 8080
  Forwarding from [::1]:8080 -> 8080
  Handling connection for 8080
  E0114 09:36:34.970485    1756 portforward.go:424] "Unhandled Error" err=< 
  an error occurred forwarding 8080 -> 8080: error forwarding port 8080 to pod e44657d5bff7aa191c726a72377564d1eb7d1bd7e5c6079fc0d48fb83d7774bf, uid : exit status 1: 
  2025/01/14 16:36:34 socat[109756] E connect(5, AF=2 127.0.0.1:8080, 16): Connection refused
  error: lost connection to pod
  ```
- **Cause**: Nginx uses the default HTTP port `80`, but the service was configured to forward traffic to port `8080`, which resulted in a connection refusal.
- **Fix**:
  - In `templates/service.yaml`, changed the `service.targetPort` from `8080` to `80` to reflect the default Nginx HTTP port.

## Final Result
At this point, I was able to successfully load the Nginx splash page in the browser:
- Executed `kubectl port-forward svc/rc-rc-homework 8080:80 -n rc-homework` again.
- The port-forwarding command now successfully forwarded traffic to port `80` on the Nginx container, and the splash page was accessible in the browser at `localhost:8080`.

## Conclusion
All issues were resolved, and the Kubernetes application was successfully deployed using Helm. The key troubleshooting steps included adjusting the namespace, fixing service and deployment configurations, correcting the image tag, and adjusting port-forwarding settings to match Nginx's default port.
