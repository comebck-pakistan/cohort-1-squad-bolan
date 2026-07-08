# Problem Research

> **Project:** AI Receivables Assistant for Pakistani FMCG Micro-Distributors  
> **Version:** 1.0  
> **Status:** Product Discovery

---

## Executive Summary

Our team initially explored building an AI bookkeeping assistant capable of automatically extracting information from invoices and maintaining accounting records. Through customer interviews, expert discussions, and mentor feedback, we discovered that bookkeeping was too broad for an 8-week MVP.

Instead, we identified a much more specific and valuable problem: **tracking customer receivables**.

Small FMCG distributors often struggle to answer simple questions such as:

- Which customer still owes me money?
- Which invoices are overdue?
- Which payments are still pending?
- Who should I follow up with today?

Our MVP focuses on solving this workflow using AI-assisted document understanding with mandatory human review.

---

# Problem Statement

Pakistani FMCG micro-distributors frequently sell products on credit.

Their receivable information is spread across:

- Paper invoices
- WhatsApp screenshots
- Notebooks
- Excel sheets
- Manual ledgers

This fragmented workflow makes payment tracking slow, repetitive and error-prone.

---

# Target User

| Attribute | Details |
|-----------|---------|
| Primary User | Pakistani FMCG Micro-Distributor |
| Business Size | Small |
| Sales Model | Credit-based |
| Current Tools | Paper, WhatsApp, Excel |
| Biggest Pain | Tracking outstanding payments |

---

# Current Workflow

```text
Credit Sale
      ↓
Invoice Created
      ↓
Paper Invoice / WhatsApp Image
      ↓
Manual Record Keeping
      ↓
Customer Ledger
      ↓
Outstanding Tracking
      ↓
Phone Call / WhatsApp Follow-up
      ↓
Payment Received
      ↓
Manual Balance Update
```

---

# Pain Points

| Pain Point | Impact |
|------------|--------|
| Information scattered | Difficult to find customer balances |
| Manual ledger updates | Time consuming |
| Duplicate data entry | Higher chance of mistakes |
| Manual reminders | Delayed collections |
| No unified dashboard | Poor visibility |

---

# Research Findings

Our research included:

- Interviews with distributors
- Discussions with accounting professionals
- ERP expert feedback
- Community discussions

### Key Findings

- Receivables are a bigger pain point than bookkeeping.
- Users prefer reviewing AI-generated data before saving.
- Invoice formats vary significantly.
- WhatsApp is already part of the business workflow.

---

# Why Receivables Instead of Bookkeeping

| Full Bookkeeping | Receivables MVP |
|------------------|-----------------|
| Large scope | Focused scope |
| Complex | Easier to validate |
| Longer development | Suitable for 8-week MVP |
| Competes with ERP | Complements existing workflow |

---

# Assumptions Tracker

| Assumption | Status |
|------------|--------|
| Users sell on credit | Validated |
| Users use WhatsApp | Validated |
| Human review is required | Validated |
| OCR alone is sufficient | Not Validated |
| Product catalog can improve mapping | To Be Tested |

---

# Risks

- Handwritten invoices
- Mixed Urdu and English text
- Different invoice layouts
- Product name inconsistencies
- User adoption

---

# Open Questions

- What extraction accuracy is acceptable?
- Should Gemini be the primary extraction model?
- How should product catalog mapping work?
- How many invoice formats should the MVP support?

---

# Success Criteria

- Users can upload invoices.
- AI extracts key fields.
- Users review and approve extracted data.
- Outstanding balances are tracked.
- Payment reminders can be sent.

---

# Key Takeaways

The research shifted our direction from building a general AI bookkeeping assistant to solving one specific business problem exceptionally well: **receivables management**.

AI is an enabling technology, not the product itself. The real value comes from simplifying the distributor's workflow while keeping the user in control through human verification.
