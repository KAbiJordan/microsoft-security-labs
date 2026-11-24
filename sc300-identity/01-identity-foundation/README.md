# Securing Bluepine Outfitters — Part 1: Identity Foundation

**Project:** Microsoft Entra ID administration, built hands-on in a live tenant
**Skills:** Entra ID · role-based access control · Microsoft Graph PowerShell · group-based licensing · B2B guest governance · hybrid identity design
**Context:** Part 1 of a multi-phase security build for Bluepine Outfitters, a fictional retail company I use as my lab environment. Every configuration below was done by me, in a real Microsoft Entra tenant, as part of my SC-300 (Identity and Access Administrator) preparation.

---

## The starting point

A fresh Entra tenant. No users, no structure, no rules.

The goal of Part 1: build the identity foundation a real company runs on — who exists, who can do what, who is licensed, who can come in from outside, and how the tenant would connect to an on-premises directory.

## What I built

### 1. Tenant and admin model
- Tenant configured with two break-glass Global Administrator accounts (emergency access, tested on day one, credentials in a password manager) and a separate daily admin account — no admin work from a personal sign-in.
- Directory roles assigned deliberately: a Helpdesk Administrator for tenant-wide support, and a **User Administrator scoped to an Administrative Unit** (Sales), so her power stops at that department's border.
- A **custom role** built from individual permissions (profile updates only), after discovering live that password reset cannot be added to a custom role — it exists only in built-in roles.

### 2. Users and groups, at two speeds
- Users created by hand, then **in bulk with Microsoft Graph PowerShell** (CSV-driven script, `New-MgUser`), because creating 100 users is scripting, not clicking.
- **Assigned groups** vs a **dynamic group** (SG-All-Staff) whose rule reads the Department attribute — new hires join automatically, and a restored user was re-pulled into the group with no human action.
- **Custom security attributes** (a CostCenter stamp on a user), which required the separate Attribute Definition / Assignment Administrator roles — even a Global Administrator is locked out of them by default.
- Delete/restore lifecycle verified through the 30-day soft-delete window.

### 3. Group-based licensing migration
- Microsoft Entra ID P2 moved from six individual assignments to **one group assignment** (SG-All-Staff). Members inherit the licence; the four script-created users were licensed without anyone touching their accounts.
- Direct assignments then removed one by one — every licence survived on inheritance alone. Final state: 10 licences consumed, exactly two assignment sources (the group, plus the daily admin's deliberate direct assignment).

### 4. Guest governance (B2B)
- Tenant defaults reviewed and **tightened**: guest invites restricted to admin roles only (from "anyone, including guests"), and guest directory access set to the most restrictive level.
- A guest (external auditor) walked through her full lifecycle — invitation, redemption, sign-in — and her restricted view verified live: she cannot enumerate a single user or group.
- The one access she needs was granted deliberately: membership in the Finance group. Guests get doors, never the building directory.

### 5. External identities and cross-tenant settings
- Identity provider inventory: Entra ID, Microsoft accounts, and Email one-time passcode configured; Google federation identified as *not* configured — the guest's Gmail sign-in actually runs on the email passcode fallback.
- Cross-tenant defaults read and understood: B2B collaboration allowed, **B2B direct connect blocked** in both directions, and **trust settings disabled** — this tenant does not accept another tenant's MFA or device claims.

### 6. Hybrid identity — design decision
Bluepine is cloud-only, so this part is a design exercise, honestly labelled. Scenario: Bluepine acquires a 200-user company with one on-prem Active Directory forest and a one-person IT team.

- **Engine: Entra Cloud Sync** — configuration lives in the cloud, the on-prem footprint is a lightweight agent, and maintenance stays near zero. Connect Sync's extra features are not required here.
- **Sign-in: Password Hash Sync** — sign-in keeps working through an on-prem outage, and it is the only method that enables leaked-credential detection in Identity Protection.
- Rollout: pilot group first, then all 200 users.

## Problems I diagnosed (not just clicked past)

- **Cloud Shell refused my admin account** ("no valid subscriptions") — Global Administrator holds no Azure subscription rights. Two separate systems: Entra directory roles vs Azure RBAC. Fixed by assigning the **Owner** RBAC role on the subscription.
- **Graph sign-in blocked, error 530035** — diagnosed from the **sign-in logs**: Security Defaults blocks the device-code flow as a phishing risk. Security Defaults was disabled (a prerequisite for Conditional Access in Part 2), with the exact policy and result read from the log's Conditional Access tab.
- **Licence assignment failed for every user** — "invalid usage location." No country on the user, no licence. Every user now gets a usage location at creation.
- **Licence management moved** — group licensing can no longer be changed in the Entra portal; it lives in the Microsoft 365 admin center. The Entra pages are read-only signposts.

## Key lessons

- **A licence is not a role.** A licence unlocks features for the tenant; a role grants a person permission to act. My break-glass accounts hold no licence and can do everything; licensed staff with no role can do nothing administrative.
- **Titles and groups grant nothing by themselves.** Only role assignments confer power — and scope (tenant-wide vs administrative unit) defines its border.
- **Dynamic systems fail silently.** A one-letter typo in a department value means no group membership and no licence — no error, anywhere. Attribute data quality *is* access control.
- **Defaults are decisions.** "Anyone can invite guests" and "trust other tenants' MFA" are shipped defaults, not recommendations. Reading them is an admin's job.

## Evidence

The configurations above are real, in a live tenant. Supporting material in this folder:

- **Architecture diagram** (`architecture-diagram.md`) — the foundation on one page.
- **The bulk-creation script** (`New-BluepineUsers.ps1`) — the actual Graph PowerShell used to create users from CSV.
- **Screenshots** (`/evidence`) — the admin model, the dynamic group at 9 members, a licence showing "Inherited (SG-All-Staff)", the licensing migration end state (10/100, group + admin only), the guest's restricted view, and the cross-tenant defaults. Tenant identifiers are cropped out; the configurations are unaltered.
- **Demo script** (`demo-script-2min.md`) — a 2-minute walkthrough of the tenant, screen by screen.

## What's next

**Part 2 — Authentication and access management:** Conditional Access policies and MFA, rebuilding as named, targeted policies the protections that Security Defaults used to provide — including MFA for admins, with the break-glass accounts excluded so a bad policy can never lock the fire exit.

---

*All names, users, and the company are fictional lab personas. No real tenant identifiers, addresses, or credentials appear in this project.*
