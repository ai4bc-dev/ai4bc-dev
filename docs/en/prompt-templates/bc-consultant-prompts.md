# Prompt Templates for BC Consultants

> A library of templates for everyday consulting work with AI.
> Copy a template, fill in the [brackets], send it to Claude or ChatGPT.

---

## Template 1: Functional Specification from Customer Notes

```
I am a BC consultant. The customer described this requirement:
[paste customer's notes, email, or meeting minutes]

Create a functional specification:
1. Header (name, customer, date, version — fill from available context or leave as placeholder)
2. Current state (how it works in BC today)
3. Desired state (what should change)
4. Business rules (conditions and logic)
5. Edge cases and exceptions
6. Impact on other parts of the system
7. Open questions (what I still need from the customer)

Format: Markdown. Language: English.
```

---

## Template 2: Test Scenarios from Specification

```
From this functional specification, generate a complete set of test scenarios:
[paste specification]

Include:
- Happy path
- Alternative valid flows
- Error states
- Edge cases (boundary values)

Each scenario:
- ID: TS-[number]
- Name: [description]
- Preconditions: [what must be true]
- Steps: [numbered]
- Expected result: [what happens]
```

---

## Template 2b: Iterating Test Scenarios — Customer Specifics

```
Add scenarios to these test scenarios for these specific customer situations:
[paste existing set of scenarios]

Customer specifics:
- [specific configuration or condition 1]
- [specific configuration or condition 2]
- [specific configuration or condition 3]

Maintain the format and ID scheme of the existing set.
```

---

## Template 2c: Export Test Scenarios to CSV

```
Convert these test scenarios to a format suitable for Excel — CSV format with semicolon delimiter.
[paste test scenarios]

Columns: ID, Name, Module, Preconditions, Steps (one line with numbering), Expected Result, Priority
```

---

## Template 3: Analyze Customer Request

```
The customer sent me this request:
[paste text]

As an experienced BC consultant, analyze:
1. What the customer probably wants (technically)
2. Implicit assumptions (what they mean but didn't say)
3. Questions for the customer before implementation
4. Potential problems with BC
5. Estimated scope of changes

BC version: [version]
```

---

## Template 3b: Preparing a Discovery Workshop

```
The customer wants to run a discovery workshop on the topic: [topic]
I have this information about the customer and their environment: [what you know]

Suggest:
1. Workshop structure (agenda, time plan)
2. Key questions I should ask
3. Areas where BC typically encounters problems for this type of requirement
4. Documents or data I should ask the customer to bring
```

---

## Template 3c: Customer Request as User Story

```
The customer's request was: [text]
Rewrite it as a user story in the format:
"As a [role], I want [action], so that [business value]."
Add Acceptance Criteria (at least 5 points).
```

---

## Template 4: User Manual

```
Write a user manual for this BC process:
[description of the process]

Target audience: [who will read it]
BC version: [version]

Format:
1. Introduction (what it is for)
2. When to use
3. Step-by-step procedure
4. Common errors and solutions
5. Notes and tips

Language: simple, no IT jargon.
```

---

## Template 4b: Updating Existing Documentation

```
This is the existing user manual:
[paste text]

The customer added this change: [description of change].

Update the manual to include this change, keeping it consistent with the existing text and format.
```

---

## Template 4c: Release Notes from Git Log

```
These are the git commits for the last [X] days:
[paste git log output]

Create release notes for the customer in business language.
Format:
- Version and date
- New features (described for users, not developers)
- Fixed bugs (if relevant to users)
- Configuration changes (if customer action is required)

The customer is non-technical. Do not explain how things work internally.
```

---

## Template 5: Meeting Minutes

```
Write formal meeting minutes from these notes:
[paste rough notes]

Format:
1. Date, attendees, location
2. Agenda
3. Discussion points
4. Decisions
5. Action items (what, who, by when)
6. Next meeting date

Tone: formal, professional.
```

---

## Template 6: Email to Customer about a Problem or Delay

```
Write a professional email to the customer:
Situation: [description of problem or delay]
What I want to communicate: [key points]
What I don't want to say: [sensitive topics]
Tone: [professional friendly / formal]
```

---

## Template 6b: Declining an Out-of-Scope Request

```
The customer requests: [what they want]
Why we cannot deliver it: [technical or business reason]
What we offer instead: [alternative]

Write an email that declines the request professionally, explains why, and offers an alternative. The customer should not feel rejected, but must understand the limitations.
```

---

## Template 6c: Weekly Status Report

```
Write a weekly project status report for the customer:

Project: [name]
Status: [% complete or phase]
Completed this week: [items]
Planned for next week: [items]
Risks or issues: [if any]
Required decisions or information from customer: [if any]

Format: Short email, no more than one page, friendly tone.
```

---

## Template 7: Troubleshooting a BC Error

```
The customer is getting this BC error:
[exact error text]

BC version: [version]
When it occurs: [description of action]
Relevant configuration: [if known]

Analyze the causes (sorted from most probable) and suggest a diagnostic procedure.
```

---

## Template 7b: Troubleshooting with Customization Context

```
The customer has these non-standard configurations:
- [customization or extension]
- [specific setting]

When [action] this behavior occurs: [description].

Which parts of the system could be causing this? How would I proceed with diagnostics?
```

---

## Template 7c: Diagnostic Instructions for the Customer

```
The customer describes this problem: [description].
The customer is non-technical.

Suggest steps I can give them as instructions for basic diagnostics.
Steps must be simple and described in non-IT language.
```

---

## Template 8: SQL Query for BC Data

```
I need a SQL query for a BC database:
[description of what I want to find out]

BC version: [version]
Conditions: [filters, time ranges]

Write a SELECT query with an explanation of the tables used and their relationships.
```

---

## Template 8b: Optimizing a Slow SQL Query

```
This SQL query on a BC database is slow (takes [X]+ seconds):
[paste query]

BC version: [version], estimated number of records in the main table: [estimate]

Analyze why it is slow and suggest optimizations. Explain each change.
```

---

## Template 8c: Diagnosing Data Anomalies

```
The customer reports: [description of data inconsistency or anomaly].

Suggest SQL queries for diagnostics:
1. [area 1 to verify]
2. [area 2 to verify]
3. [area 3 to verify]

BC version: [version]
```
