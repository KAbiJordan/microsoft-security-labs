# Demo script — Bluepine Identity Foundation (about 2 minutes)

Screen-record this in your tenant when you're ready (Loom or any recorder).
Show, don't describe: every stop is a screen you actually built.
Before recording: crop or avoid the Object Id columns and the tenant domain in UPNs.

| Time | Show on screen | Say (your words — adjust freely) |
|---|---|---|
| 0:00 | Entra admin center home, tenant overview | "This is Bluepine Outfitters, a lab company I administer in Microsoft Entra ID. In Part 1 I built its identity foundation." |
| 0:15 | Users → Maya Chen → Assigned roles | "Admin power is assigned by role, not by job title. Maya is Helpdesk Administrator for the tenant…" |
| 0:30 | Admin units → AU-Sales → her User Administrator assignment | "…and User Administrator only inside this administrative unit — Sales. Her power has a border." |
| 0:45 | Groups → SG-All-Staff → Members (9) | "This group is dynamic. The rule reads each person's department and pulls them in automatically — nobody maintains this list." |
| 1:00 | Users → Nina Park → Licenses | "Nina was created by my PowerShell script. Her P2 licence says Inherited — it flows from the group. I never touched her account." |
| 1:20 | M365 admin center → Licenses → P2 (10/100, group entry) | "All staff licences come from one group assignment. That's the migration: from six manual assignments to one." |
| 1:35 | Switch to Dana's session → Users page (insufficient privileges) | "This is our external auditor, a guest. This is everything she can see of our directory: nothing. Her one access was given deliberately, through one group." |
| 1:50 | Back to admin view — Dana's profile (Guest, #EXT#) | "Guests get doors, never the building directory. Next in Part 2: Conditional Access and MFA." |

## Recording notes
- Two windows ready before you start: abi.admin (admin view) and Dana's private window (guest view) — the switch at 1:35 is the strongest moment of the demo.
- If a screen shows an Object Id or the full tenant domain, pause and crop, or re-record that segment.
- One take is fine. A calm walkthrough beats a polished one — hiring managers watch for understanding, not editing.
