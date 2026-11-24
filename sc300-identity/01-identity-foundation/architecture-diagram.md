# Bluepine Outfitters — Identity Foundation: Architecture

Paste the diagram below into the GitHub README (GitHub renders Mermaid automatically),
or keep this file beside it in `sc300-identity/01-identity-foundation/`.

```mermaid
flowchart TB
    subgraph TENANT["Bluepine Outfitters (Lab) — Microsoft Entra tenant"]
        direction TB

        subgraph ADMIN["Admin model"]
            BG["Break-glass x2<br/>Global Administrator<br/>(emergency only, no licence)"]
            ABI["abi.admin<br/>Global Administrator<br/>(daily admin)"]
            MAYA["Maya Chen<br/>Helpdesk Administrator (tenant)<br/>User Administrator (AU-Sales only)"]
            AU["AU-Sales<br/>Jordan Lee · Priya Nair"]
            MAYA -->|scoped to| AU
        end

        subgraph PEOPLE["People"]
            STAFF["9 staff users<br/>IT · Sales · Warehouse · Finance"]
            SCRIPT["New-MgUser script (CSV)<br/>created 4 of them in bulk"]
            SCRIPT -->|creates| STAFF
        end

        subgraph GROUPS["Groups"]
            ALL["SG-All-Staff — DYNAMIC<br/>rule: department in IT/Sales/Warehouse/Finance"]
            FIN["SG-Finance — assigned<br/>Alex Novak + Dana Reid (guest)"]
            STAFF -->|rule matches automatically| ALL
        end

        subgraph LIC["Licensing"]
            P2["Microsoft Entra ID P2<br/>10 / 100 consumed"]
            ALL -->|group assignment → inheritance| P2
            ABI -->|direct assignment (deliberate)| P2
        end

        subgraph EXT["External access"]
            DANA["Dana Reid — Guest<br/>signs in by Email one-time passcode"]
            XTD["Cross-tenant defaults<br/>B2B collaboration: allowed<br/>B2B direct connect: blocked<br/>Trust settings: disabled"]
            DANA -->|member of| FIN
        end
    end

    HYB["Design only — NorthPeak acquisition<br/>Entra Cloud Sync + Password Hash Sync"]
    TENANT -.->|future hybrid| HYB
```

## How to read it (the 20-second version)

- **Admin model:** power is fenced. Break-glass accounts exist only for emergencies; the daily admin is a separate account; Maya's strongest role is scoped to one department's administrative unit.
- **People → Groups:** staff land in SG-All-Staff *by rule*, not by hand — that one membership drives their licence.
- **Licensing:** one group assignment carries all 9 staff; the admin's direct assignment is a separate, deliberate wire.
- **External:** the guest holds exactly one group membership and cannot browse the directory — verified from her own sign-in.
- **Dashed line:** hybrid identity is a written design (Cloud Sync + PHS), not a live sync — labelled honestly.
