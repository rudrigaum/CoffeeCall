## 📋 Overview

<!--
Briefly describe what this Pull Request changes and why it is necessary.
Keep the explanation focused on the problem and the proposed solution.
-->

## ✅ What's Included

<!-- List the main changes introduced by this Pull Request. -->

-
-
-

## 🔗 Related Issue

<!--
Link the related issue when applicable.
Remove this section if there is no related issue.
-->

Closes #

## 🧪 How to Test

<!--
Provide clear steps for manually validating the change.
Include relevant scenarios and edge cases when applicable.
-->

1.
2.
3.

## 📸 Screenshots / Screen Recording

<!--
Required for meaningful UI changes.
Remove this section when it does not apply.
-->

| Before | After |
|---|---|
| | |

## 🏗 Architecture Notes

<!--
Describe architectural decisions, trade-offs, or deviations that reviewers
should pay attention to.

Remove this section if the change has no relevant architectural impact.
-->

## 📝 Additional Notes

<!--
Add known limitations, follow-up work, migration details, or anything else
reviewers should know.

Remove this section when unnecessary.
-->

## ✔️ Checklist

### General

- [ ] The project builds successfully
- [ ] No new compiler warnings were introduced
- [ ] The change is limited to the scope of this Pull Request
- [ ] Naming is clear and follows project conventions
- [ ] No sensitive information or secrets were committed

### Architecture

- [ ] Clean Architecture and MVVM-C boundaries were respected
- [ ] Dependencies are explicitly injected
- [ ] Navigation remains Coordinator-driven
- [ ] Views contain no business logic
- [ ] No unnecessary abstraction or shared component was introduced

### Concurrency & Memory

- [ ] `async/await` is used for asynchronous I/O when applicable
- [ ] Combine is limited to presentation bindings when applicable
- [ ] Closures and delegates were reviewed for retain cycles

### Testing

- [ ] Relevant unit tests were added or updated when applicable
- [ ] Existing tests continue to pass
- [ ] Important edge cases were considered

### UI

- [ ] UIKit screens remain programmatic and use View Code
- [ ] Layout uses native Auto Layout / `NSLayoutAnchor`
- [ ] UI changes were manually validated
- [ ] Accessibility was considered when applicable

### Documentation

- [ ] Documentation was updated when the change affects documented behavior or architecture
