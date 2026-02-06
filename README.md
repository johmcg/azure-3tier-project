# Azure 3-Tier Network Infrastructure (IaC)

## 🎯 Project Objective
This project serves as the foundational infrastructure for a secure, scalable 3-tier web application. My goal is to demonstrate professional-grade **Infrastructure as Code (IaC)** practices using Terraform while preparing for the **AZ-104 (Azure Administrator Associate)** exam in April.

---

## 🏗️ Architecture Design
The network is built using a hub-and-spoke logic within a single Virtual Network, segregated by subnets to enforce security boundaries.

- **VNet Address Space:** `10.0.0.0/16`
- **Subnets (/24):**
  - `snet-frontend`: 10.0.1.0/24 Public-facing tier for Web Servers/Load Balancers.
  - `snet-backend`: 10.0.2.0/24 Private tier for Application Logic.
  - `snet-database`: 10.0.3.0/24 Isolated tier for Data Storage (No direct internet access).
  - `snet-management`: 10.0.4.0/24 Management tier for Admin/Jumpbox access.

---

## 🛡️ Security & Traffic Lockdown (Phase 2)
In Phase 2, I implemented a **Zero-Trust** approach by isolating each tier with dedicated **Network Security Groups (NSGs)** and explicit Subnet Associations.



### Security Rules Implemented:
| Tier | NSG Name | Security Policy | Logic |
| :--- | :--- | :--- | :--- |
| **Frontend** | `nsg-frontend` | Default (Locked) | Prepared for Port 80/443 public access. |
| **Backend** | `nsg-backend` | Default (Locked) | Internal application logic isolation. |
| **Database** | `nsg-database` | **AllowBackendInbound** | **Priority 100:** Only accepts TCP 3306 from Backend subnet. |
| **Management**| `nsg-management`| Default (Locked) | Prepared for restricted SSH/RDP access. |

---

## 🛠️ Technology Stack
* **Cloud:** Microsoft Azure
* **IaC:** Terraform (HCL)
* **Tooling:** Azure CLI, VS Code, Git

---

## 🗺️ Roadmap: The Road to June
This repository is a work-in-progress as I build out the full stack for my portfolio.

- [x] **Phase 1:** Core Networking (VNet, Subnets, Resource Groups) - **COMPLETE**
- [x] **Phase 2:** Network Security Groups (NSGs) & Traffic Lockdown - **COMPLETE**
- [ ] **Phase 3:** Compute Layer (Virtual Machines & Load Balancer)
- [ ] **Phase 4:** Managed Database Tier (Azure SQL)
- [ ] **Phase 5:** CI/CD Integration with GitHub Actions

---

## 🧠 Lessons Learned & Troubleshooting
1. **Entra ID MFA (AADSTS50076):** Resolved CLI authentication issues caused by Conditional Access policies by forcing a tenant-specific login: `az login --tenant <TENANT_ID>`.
2. **Variable-Driven Security Rules:** Instead of hardcoding IPs in rules, I mapped `source_address_prefix` to Terraform variables. This ensures that if a subnet prefix changes, the firewall rules update automatically, preventing "configuration drift."
3. **Stateful vs. Stateless:** Mastered the logic of Azure's **Stateful** NSGs—understanding that allowing inbound traffic on Port 3306 automatically allows the response to flow back to the source without needing a matching outbound rule.
4. **NSG Association:** Learned that creating an NSG is only half the battle; it must be explicitly associated with a subnet via `azurerm_subnet_network_security_group_association` to actually protect the resources.

---

## 🚀 How to Run Locally
1. **Clone:** `git clone https://github.com/johmcg/azure-3tier-project.git`
2. **Authenticate:** `az login`
3. **Initialize:** `terraform init`
4. **Plan:** `terraform plan`
5. **Apply:** `terraform apply`