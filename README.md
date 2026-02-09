# Azure 3-Tier Network Infrastructure (IaC)

## 🎯 Project Objective
This project serves as the foundational infrastructure for a secure, scalable 3-tier web application. My goal is to demonstrate professional-grade **Infrastructure as Code (IaC)** practices using Terraform while preparing for the **AZ-104 (Azure Administrator Associate)** exam in April.

---

## 🏗️ Architecture Design
The network is built using a hub-and-spoke logic within a single Virtual Network, segregated by subnets to enforce security boundaries.

- **VNet Address Space:** `10.0.0.0/16`
- **Subnets (/24):**
  - `snet-frontend`: 10.0.1.0/24 Public-facing tier for the **Azure Standard Load Balancer**.
  - `snet-backend`: 10.0.2.0/24 Private tier for **Virtual Machines** (No Public IP).
  - `snet-database`: 10.0.3.0/24 Isolated tier for Data Storage (No direct internet access).
  - `snet-management`: 10.0.4.0/24 Management tier for Admin/Jumpbox access.

---

## 🛡️ Security & Traffic Lockdown
I implemented a **Zero-Trust** approach by isolating each tier with dedicated **Network Security Groups (NSGs)** and explicit Subnet Associations.

### Security Rules Implemented:
| Tier | NSG Name | Security Policy | Logic |
| :--- | :--- | :--- | :--- |
| **Frontend** | `nsg-frontend` | **AllowHTTPInbound** | **Priority 110:** Allows Port 80 for the Load Balancer frontend. |
| **Backend** | `nsg-backend` | **AllowLBInbound** | **Priority 100:** Allows Azure Load Balancer health probes. |
| **Backend** | `nsg-backend` | **AllowAnyHTTPInbound**| **Priority 110:** Permits user traffic from the Internet to reach the private VM. |
| **Database** | `nsg-database` | **AllowBackendInbound** | **Priority 100:** Only accepts TCP 3306 from Backend subnet. |
| **Management**| `nsg-management`| Default (Locked) | Prepared for restricted SSH/RDP access. |

---

## ✅ Phase 3 Verification (Compute & Load Balancing)
To verify the high-availability architecture, I performed the following:
1. **Bootstrap Automation:** Used `custom_data` (Cloud-init) to automatically install and start Nginx on VM creation.
2. **Infrastructure Decoupling:** Moved the VM to a private backend subnet and removed its Public IP, ensuring all traffic must pass through the Load Balancer.
3. **Standard LB Configuration:** Implemented **Outbound Rules** and **SNAT** logic to allow private VMs to communicate with Azure's health probe system.
4. **Health Verification:** Successfully confirmed the Backend Pool health state via Azure Insights and accessed the Nginx "Welcome" page via the **Load Balancer's Public IP**.

---

## 🗺️ Roadmap:
- [x] **Phase 1:** Core Networking (VNet, Subnets, Resource Groups) - **COMPLETE**
- [x] **Phase 2:** Network Security Groups (NSGs) & Traffic Lockdown - **COMPLETE**
- [x] **Phase 3:** Compute Layer (Virtual Machines & Load Balancer) - **COMPLETE**
  - [x] Provisioned Ubuntu 22.04 LTS via Terraform.
  - [x] Automated SSH Key injection for secure access.
  - [x] Automated Nginx deployment via Cloud-Init.
  - [x] Implemented Azure Standard Load Balancer with HTTP Health Probes.
  - [x] Configured Outbound Rules for NAT/SNAT connectivity.
- [ ] **Phase 4:** Managed Database Tier (Azure SQL)
- [ ] **Phase 5:** CI/CD Integration with GitHub Actions

---

## 🧠 Lessons Learned & Troubleshooting
1. **Entra ID MFA (AADSTS50076):** Resolved CLI authentication issues caused by Conditional Access policies by forcing a tenant-specific login: `az login --tenant <TENANT_ID>`.
2. **Standard LB Outbound Connectivity:** Learned that Standard SKU Load Balancers require an explicit **Outbound Rule** for private VMs to respond to Health Probes.
3. **SNAT Conflicts:** Resolved the `LoadBalancingRuleMustDisableSNAT` error by disabling outbound SNAT on the Load Balancing rule when using a dedicated Outbound Rule.
4. **Service Tag Precision:** Leveraged the `AzureLoadBalancer` service tag to allow health checks without exposing the VM to the entire internet.
5. **Stateful vs. Stateless:** Mastered the logic of Azure's **Stateful** NSGs, eliminating the need for redundant outbound response rules.
6. **Bootstrap Automation (Cloud-Init):** Utilized `custom_data` and `base64encode` to ensure the VM is ready to serve traffic the moment it is provisioned.

---

## 🚀 How to Run Locally
1. **Clone:** `git clone https://github.com/johmcg/azure-3tier-project.git`
2. **Authenticate:** `az login`
3. **Initialize:** `terraform init`
4. **Apply:** `terraform apply`
5. **Cleanup:** `terraform destroy`