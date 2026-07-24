# BUG-001: Expense Ordering Fix

## Summary

The expense history list should display expenses ordered by their expense `date` in descending order, so the most recent expense dates appear first.

## Root Cause

The backend API was sorting expenses by `created_at` instead of `date`. This caused the UI to receive an order based on record insertion time rather than the expense date entered by the user.

## Fix

In `backend/app/controllers/api/expenses_controller.rb`, the `index` action was updated to:

- order expenses with `order(date: :desc)`
- filter monthly results using `where(date: start_date..end_date)` for the `date` column

## Verification

1. Request expenses for a specific month via `/api/expenses?year=2026&month=2`
2. Confirm the API returns only February expenses
3. Confirm the returned expenses are sorted with the newest `date` values first

## Notes

This change keeps the API aligned with the UI expectation that expense lists are ordered by expense date, not creation timestamp.