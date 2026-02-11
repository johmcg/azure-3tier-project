# Azure 3-Tier Network Infrastructure (IaC)

**Tech Stack:** ![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

## 🎯 Project Objective
This project serves as the foundational infrastructure for a secure, scalable 3-tier web application. My goal is to demonstrate professional-grade **Infrastructure as Code (IaC)** practices using Terraform while preparing for the **AZ-104 (Azure Administrator Associate)** exam in April.

---

## 🏗️ Architecture Design
The network follows a hub-and-spoke logic within a single Virtual Network, deployed in **East US 2** to ensure high availability and resource capacity.

- **VNet Address Space:** `10.0.0.0/16`
- **Subnets (/24):**
  - `snet-frontend`: Public-facing tier for the **Azure Standard Load Balancer**.
  - `snet-backend`: Private tier for **Virtual Machines** (Internal traffic only).
  - `snet-database`: Isolated tier for **Azure SQL** with Service Endpoints.
  - `snet-management`: Management tier for Admin/Jumpbox access.

---

## 🛡️ Security & Traffic Lockdown
I implemented a **Zero-Trust** approach by isolating each tier with dedicated **Network Security Groups (NSGs)** and **Virtual Network Service Endpoints**.

### Security Rules Implemented:
| Tier | NSG Name | Security Policy | Logic |
| :--- | :--- | :--- | :--- |
| **Frontend** | `nsg-frontend` | **AllowHTTPInbound** | **Port 80:** Allows traffic for the Load Balancer. |
| **Backend** | `nsg-backend` | **AllowLBInbound** | **Health Probes:** Allows Azure LB to monitor VM health. |
| **Backend** | `nsg-backend` | **AllowAnyHTTPInbound**| **Traffic Flow:** Permits user traffic from LB to private VMs. |
| **Database** | `nsg-database` | **AllowBackendSQL** | **Port 1433:** Only accepts TCP from the Backend subnet. |

---

## ✅ Phase 4 Verification (Managed Database Tier)
To secure the data layer and finalize the 3-tier stack:
1. **PaaS Integration:** Provisioned an **Azure SQL Database** (Basic SKU) with a globally unique DNS name using `random_integer`.
2. **Network Isolation:** Enabled **Microsoft.Sql Service Endpoints** on the **backend subnet** to ensure traffic never leaves the Azure backbone while communicating with the database.
3. **VNet Rules:** Applied an `azurerm_mssql_virtual_network_rule` to explicitly whitelist the backend app tier while blocking all public internet access.
4. **Regional Pivot:** Migrated the entire stack from `eastus` to `eastus2` to resolve regional capacity constraints.

---

## 🗺️ Roadmap:
- [x] **Phase 1:** Core Networking (VNet, Subnets, Resource Groups) - **COMPLETE**
- [x] **Phase 2:** Network Security Groups (NSGs) & Traffic Lockdown - **COMPLETE**
- [x] **Phase 3:** Compute Layer (Virtual Machines & Load Balancer) - **COMPLETE**
- [x] **Phase 4:** Managed Database Tier (Azure SQL) - **COMPLETE**
- [ ] **Phase 5:** CI/CD Integration with GitHub Actions

---

## 🧠 Lessons Learned & Troubleshooting
1. **Regional Capacity & Pivot:** Encountered `ProvisioningDisabled` in `eastus` due to Azure regional limits. Successfully performed a regional migration to `eastus2`, learning that networking resources (VNets/IPs) have "regional gravity" and must be recreated during a move.
2. **Infrastructure Integrity (State Reconciliation):** Managed "Inconsistent Result" and "Resource Already Exists" errors by reconciling the local Terraform state with Azure Portal reality using `terraform import` after a manual resource group cleanup.
3. **Service Endpoint Scope:** Discovered that **Virtual Network Rules** for SQL require the **client subnet** (Backend) to have the `Microsoft.Sql` endpoint enabled, as the VMs are the initiators of the connection.
4. **Entra ID MFA (AADSTS50076):** Resolved CLI authentication issues caused by Conditional Access policies by forcing a tenant-specific login: `az login --tenant <TENANT_ID>`.
5. **Standard LB Outbound Connectivity:** Learned that Standard SKU Load Balancers require an explicit **Outbound Rule** for private VMs to respond to Health Probes.
6. **SNAT Conflicts:** Resolved the `LoadBalancingRuleMustDisableSNAT` error by disabling outbound SNAT on the Load Balancing rule when using a dedicated Outbound Rule.
7. **Service Tag Precision:** Leveraged the `AzureLoadBalancer` service tag to allow health checks without exposing the VM to the entire internet.
8. **Stateful vs. Stateless:** Mastered the logic of Azure's **Stateful** NSGs, eliminating the need for redundant outbound response rules.
9. **Bootstrap Automation (Cloud-Init):** Utilized `custom_data` and `base64encode` to ensure the VM is ready to serve traffic the moment it is provisioned.

---

## 🚀 How to Run Locally
1. **Clone:** `git clone https://github.com/johmcg/azure-3tier-project.git`
2. **Authenticate:** `az login`
3. **Initialize:** `terraform init`
4. **Apply:** `terraform apply`