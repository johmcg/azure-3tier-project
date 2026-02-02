# Azure 3-Tier Network Infrastructure (IaC)

## 🎯 Project Objective
This project serves as the foundational infrastructure for a secure, scalable 3-tier web application. My goal is to demonstrate professional-grade **Infrastructure as Code (IaC)** practices using Terraform while preparing for the **AZ-104 (Azure Administrator Associate)** exam in April.

---

## 🏗️ Architecture Design
The network is built using a hub-and-spoke logic within a single Virtual Network, segregated by subnets to enforce security boundaries.

- **VNet Address Space:** `10.0.0.0/16`
- **Subnets (/24):**
  - `snet-frontend`: Public-facing tier for Web Servers/Load Balancers.
  - `snet-backend`: Private tier for Application Logic.
  - `snet-database`: Isolated tier for Data Storage (No direct internet access).



---

## 🛠️ Technology Stack
* **Cloud:** Microsoft Azure
* **IaC:** Terraform (HCL)
* **Tooling:** Azure CLI, VS Code, Git

---

## 🗺️ Roadmap: The Road to June
This repository is a work-in-progress as I build out the full stack for my portfolio.
- [x] **Phase 1:** Core Networking (VNet & Subnets) - *Current Status*
- [ ] **Phase 2:** Network Security Groups (NSGs) & Traffic Lockdown
- [ ] **Phase 3:** Compute Layer (Virtual Machines & Load Balancer)
- [ ] **Phase 4:** Managed Database Tier (Azure SQL)
- [ ] **Phase 5:** CI/CD Integration with GitHub Actions

---

## 🧠 Lessons Learned & Troubleshooting
During the initial deployment, I successfully navigated several "real-world" Azure hurdles:

1. **Entra ID MFA (AADSTS50076):** Resolved CLI authentication issues caused by Conditional Access policies by forcing a tenant-specific login: `az login --tenant <TENANT_ID>`.
2. **Provider Registration Handshake:** Optimized Terraform performance by implementing `skip_provider_registration = true` to bypass unnecessary background checks for unused Azure Resource Providers.
3. **Terraform State Management:** Configured `.gitignore` to protect sensitive `.tfstate` files, ensuring no cloud infrastructure IDs or secrets are leaked to the public repo.

---

## 🚀 How to Run Locally
1. **Clone:** `git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git`
2. **Authenticate:** `az login`
3. **Initialize:**