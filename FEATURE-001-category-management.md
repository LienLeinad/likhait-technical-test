# Feature Notes and Design Decisions

## Overview

This document records the work completed for the category management feature in the expense tracking application.

## Scope of work

Users can now create new categories from the expense form and use them immediately when creating an expense.

---

## Backend design decisions

### Category API contract

A new category creation endpoint was added to the API.

- The create request expects a nested payload shape:
  - `POST /api/categories`
  - body: `{ "category": { "name": "New Category" } }`
- The backend responds with a JSON object for the created category.
- Validation errors return a `422 Unprocessable Entity` response with the validation messages.

This choice was made to keep the API consistent with Rails conventions and the existing JSON-based request pattern.

Relevant implementation areas:
- [backend/app/controllers/api/categories_controller.rb](backend/app/controllers/api/categories_controller.rb)
- [backend/app/models/category.rb](backend/app/models/category.rb)
- [backend/config/routes.rb](backend/config/routes.rb)

### Validation approach

Category names are validated before save.

- Blank names are rejected.
- Very short or invalid values are rejected through model validation.
- This ensures the API fails gracefully instead of silently accepting bad input.

---

## Frontend design decisions

### Categories are loaded from the API

The expense form no longer relies on a hardcoded category list.

- Categories are fetched from the backend when the form loads.
- The form uses the returned category names as dropdown options.
- This keeps the UI in sync with whatever categories exist in the database.

Relevant implementation areas:
- [frontend/src/components/ExpenseForm.tsx](frontend/src/components/ExpenseForm.tsx)
- [frontend/src/services/api.ts](frontend/src/services/api.ts)

### Add Category flow

A small “Add Category” action was added next to the category dropdown.

- Clicking it prompts the user for a category name.
- The new category is sent to the backend API.
- After a successful create, the category list is refreshed.
- The newly created category is immediately selected in the form.

This was chosen to keep the experience lightweight and avoid forcing the user to leave the expense form.

### Emoji handling

Category emojis are currently handled through a static mapping rather than being stored in the database.

- The app uses a lookup map in [frontend/src/constants/categoryEmojis.ts](frontend/src/constants/categoryEmojis.ts).
- If a category name is not present in the mapping, the UI falls back to a default emoji.
- This keeps the implementation simple but means custom categories do not automatically receive a unique emoji unless a mapping is added.

---

## Testing and verification

### Backend request specs

Request specs were added and updated to cover:

- category listing
- successful category creation
- invalid category creation handling

Relevant test files:
- [backend/spec/requests/api/categories_spec.rb](backend/spec/requests/api/categories_spec.rb)

### Manual validation

The feature was validated in the local application flow by exercising:

- expense creation with an existing category
- category creation from the form
- reloading the form and seeing the new category available

---

## Notes for future improvement

Potential follow-up improvements include:

- storing category emojis in the database so custom categories can have their own visual identity
- adding category edit/delete flows
- improving validation messages in the UI
- adding stronger end-to-end coverage for the full create-expense flow
