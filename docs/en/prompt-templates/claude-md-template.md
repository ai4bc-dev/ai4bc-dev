# [Project Name] — CLAUDE.md Template

## Project
[Short description of what the extension does, for which customer, in which BC version]
BC version: [27]. Publisher: [company]. Prefix: [ZZ_].

## Key Tables
- Table [50100]: [Name] — [description, key fields]
- Table [50101]: [Name] — [description, key fields]

## Conventions
- Naming prefix: [ZZ_]
- Comments: [English / Czech]
- Error handling: Error() for business errors, TestField() for validations
- Procedures: PascalCase
- Tests: [required / optional], prefix Test_

## What Claude Must NOT Do Without Approval
- Do not modify existing public procedures
- Do not use direct SQL or RecordRef
- Do not create new tables
- Do not change object numbers or ID ranges
- Do not remove existing code

## Typical Tasks
- [Adding new ... ]
- [Fixing bugs in ... ]
- [Writing documentation for ... ]
