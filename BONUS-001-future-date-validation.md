# BONUS-001: Prevent Future Date Expense Creation

## Summary

Add validation to prevent users from creating expenses with dates in the future. Expenses should only be allowed for today or past dates.

## What changed

### Backend

- Added a model-level validation in [backend/app/models/expense.rb](backend/app/models/expense.rb) to reject dates later than today.
- The validation returns a clear error message: `cannot be in the future`.
- This ensures the API rejects invalid expense data before it is persisted.

### Frontend

- The expense form now validates the selected date before submission in [frontend/src/hooks/useExpenseForm.ts](frontend/src/hooks/useExpenseForm.ts).
- The date input uses a `max` attribute in [frontend/src/components/ExpenseForm.tsx](frontend/src/components/ExpenseForm.tsx) so the browser/date picker prevents selecting future dates.
- The API layer in [frontend/src/services/api.ts](frontend/src/services/api.ts) now surfaces backend validation errors so the form can display them to the user.

## Design decisions

- Validation is enforced at the backend model layer to keep the business rule consistent regardless of client usage.
- The frontend adds a quick user-facing guard so invalid dates are blocked earlier in the experience.
- API errors are passed through to the form so users receive a clear explanation instead of a generic failure.

## Testing

The bonus task is covered by backend specs for both the model and request layer:

- [backend/spec/models/expense_spec.rb](backend/spec/models/expense_spec.rb)
- [backend/spec/requests/api/expenses_spec.rb](backend/spec/requests/api/expenses_spec.rb)

## Notes

This bonus task complements the earlier category-management feature and expense ordering fix by improving data quality at the point of expense entry.
