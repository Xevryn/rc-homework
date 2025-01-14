### **Software Engineering/Infrastructure Homework Assignment**

#### **Overview**
This troubleshooting-focused assignment evaluates your ability to diagnose and resolve issues in a Kubernetes environment. You'll work with a pre-built Helm chart and Terraform configuration to deploy a broken container to a local Kubernetes cluster. Your task is to identify and fix the issues, document your process, and implement a working solution.

#### **Task**
You are provided with:
1. A Helm chart that deploys a simple Kubernetes application.
2. A Terraform configuration that sets up the Kubernetes namespace for the application.

However, the application does not work as expected. Your job is to:
1. Identify the issues.
2. Propose and implement fixes.
3. Document your troubleshooting process.

---

#### **Details**

1. **Setup**:
   - Deploy the application using the provided Helm chart and Terraform configuration. Use a local Kubernetes environment like [Minikube](https://minikube.sigs.k8s.io/docs/) or [Kind](https://kind.sigs.k8s.io/docs/).
   - The application consists of:
     - A Deployment that runs a container.
     - A Service of type `ClusterIP` exposing the container.

2. **Troubleshooting Requirements**:
   - Diagnose any issues in both the Helm chart and Terraform configuration.
   - Implement fixes to:
     - Ensure the application deploys successfully.
     - Verify the application is accessible via the Service.
   - Document your process and the root causes of the issues.

---

#### **Deliverables**

- **Updated Files**:
  - Submit the fixed Helm chart and Terraform configuration.
  - Include a `README.md` detailing the issues found, how you resolved them, and verification steps.
  - The code should be placed on GitHub or a similar platform so that we can review your changes.
- **Validation**:
  - Provide evidence of the fixed deployment
    - logs
    - screenshots of working Pods and Services
    - screenshots of terraform plans and applies

---

#### **Evaluation Rubric**
| **Criteria**                  | **Weight** | **Description**                                                                                     |
|-------------------------------|------------|-----------------------------------------------------------------------------------------------------|
| **Troubleshooting Skills**    | 40%        | Clear identification of issues, accurate root cause analysis, and effective resolutions.            |
| **Correctness**               | 30%        | Application deploys successfully, is accessible, and issues are fully resolved.                    |
| **Documentation**             | 20%        | Detailed and clear explanation of the troubleshooting process, fixes applied, and validation steps. |
| **Code Quality**              | 10%        | Clean and well-organized updates to the Helm and Terraform files.                                  |

---
