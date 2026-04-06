# Prompt Templates for BC Developers

> A library of ready-made templates for everyday AL development with AI.
> Copy a template, fill in the [brackets], send it to Claude or ChatGPT.

---

## Template 1: New AL Codeunit

```
I am a BC developer, working with Business Central version [version].
Project: [brief description of the project or extension]

I need to write a codeunit that [description of functionality].

Context:
- Relevant tables: [list of tables with descriptions]
- Workflow: [description of when and how the codeunit is called]
- Edge cases: [list of exceptions or special situations]
- Existing pattern in the project: [description or example of existing code]

Conventions:
- Naming prefix: [prefix]
- Comments: [Czech/English]
- Error handling: [Error() / TestField() / custom]

Write complete AL code with comments.
```

---

## Template 2: Debug Runtime Error

```
I have AL code that causes this runtime error:
[exact error message]

Code where the error occurs:
[paste the relevant code]

BC version: [version]
Context: [when exactly the error occurs]

Analyze the cause, suggest a fix, and explain what was causing it.
```

---

## Template 3: Debug Compile Error

```
I am getting these compile errors when building my AL extension:
[paste list of errors with line numbers]

Relevant code:
[paste code]

BC version: [version]

Fix the errors and explain each fix.
```

---

## Template 4: Code Review

```
Perform a code review of this AL code:
[paste code]

Focus on:
1. Performance — unnecessary DB queries, missing SetLoadFields
2. Error handling — are edge cases covered?
3. Security — are permissions checked correctly?
4. Maintainability — readability, comments, naming
5. BC best practices — consistency with AL conventions in [version]

For each issue found: Description + suggested fix + example.
```

---

## Template 5: Refactoring

```
This AL code works, but [problem: it's too long / duplicated / hard to read].

Code:
[paste code]

Refactoring goal: [specific goal]
Constraints: [what you cannot change — public interface, existing data]
BC version: [version]

Suggest a refactoring. For each change: what you're changing and why.
```

---

## Template 6: New Table Extension

```
I need to add fields to the standard BC table [table name] via a table extension.

Fields:
- [field name] ([data type], [length]): [description of purpose]

Conventions:
- Field prefix: [prefix]
- DataClassification: [CustomerContent / SystemMetadata / per GDPR rules]
- BC version: [version]

Write a table extension.
```

---

## Template 7: Event Subscriber

```
I need an event subscriber for [event name] in [codeunit/table/page].

What the subscriber should do: [description]
Relevant tables or data: [list]
Conditions: [when should the logic fire]

BC version: [version]
Naming prefix: [prefix]

Write an event subscriber with business logic.
```

---

## Template 8: Analyze Customer Request

```
A customer sent me this request for BC:
[paste email text or description]

Analyze and suggest:
1. Complete list of things to implement
2. What BC objects will be needed
3. Edge cases the customer probably didn't think about
4. Questions for the customer before implementation

BC version: [version]
```

---

## Template 9: Technical Code Documentation

```
Write technical documentation for this AL code:
[paste code]

Documentation should include:
- Purpose and functionality
- Description of input parameters and return value
- Business logic step by step
- Known limitations and edge cases
- Usage example

Format: Markdown. Language: English.
```

---

## Template 10: Generate Test Data

```
I need AL code to create test data:
[description of the test scenario]

Required records:
- [table]: [count, key values]

Dependencies: [Y must exist before X]
BC version: [version]

Write a procedure or codeunit to create the data.
```
