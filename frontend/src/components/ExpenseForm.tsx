/**
 * Form component for adding/editing expenses
 */

import React, { useEffect, useState } from "react";
import { ExpenseFormData } from "../types";
import { TextField, SelectBox, Button } from "../vibes";
import { useExpenseForm } from "../hooks/useExpenseForm";
import { createCategory, fetchCategories } from "../services/api";

interface ExpenseFormProps {
  initialData?: Partial<ExpenseFormData>;
  onSubmit: (data: ExpenseFormData) => Promise<void>;
  onCancel?: () => void;
  submitLabel?: string;
}

export function ExpenseForm({
  initialData,
  onSubmit,
  onCancel,
  submitLabel = "Add Expense",
}: ExpenseFormProps) {
  const { formData, errors, isSubmitting, handleChange, handleSubmit } =
    useExpenseForm({
      initialData,
      onSubmit,
    });
  const [categoryOptions, setCategoryOptions] = useState<
    Array<{ value: string; label: string }>
  >([]);
  const [isCreatingCategory, setIsCreatingCategory] = useState(false);

  useEffect(() => {
    const loadCategories = async () => {
      try {
        const categories = await fetchCategories();
        setCategoryOptions(
          categories.map((category) => ({
            value: category.name,
            label: category.name,
          })),
        );
      } catch (error) {
        console.error("Failed to load categories:", error);
      }
    };

    loadCategories();
  }, []);

  const formStyle: React.CSSProperties = {
    display: "flex",
    flexDirection: "column",
    gap: "1rem",
  };

  const buttonGroupStyle: React.CSSProperties = {
    display: "flex",
    gap: "0.5rem",
    marginTop: "0.5rem",
  };

  const handleAddCategory = async () => {
    const newCategoryName = window.prompt("Enter a new category name");
    if (!newCategoryName) {
      return;
    }

    const trimmedName = newCategoryName.trim();
    if (!trimmedName) {
      return;
    }

    try {
      setIsCreatingCategory(true);
      await createCategory(trimmedName);
      const categories = await fetchCategories();
      setCategoryOptions(
        categories.map((category) => ({
          value: category.name,
          label: category.name,
        })),
      );
      handleChange("category", trimmedName);
    } catch (error) {
      console.error("Failed to create category:", error);
      alert("Failed to create category");
    } finally {
      setIsCreatingCategory(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} style={formStyle}>
      <TextField
        label="Amount"
        type="number"
        step="0.01"
        placeholder="0.00"
        value={formData.amount}
        onChange={(e) => handleChange("amount", e.target.value)}
        error={errors.amount}
        fullWidth
        required
      />

      <TextField
        label="Description"
        type="text"
        placeholder="Enter description"
        value={formData.description}
        onChange={(e) => handleChange("description", e.target.value)}
        error={errors.description}
        fullWidth
        required
      />

      <div style={{ display: "flex", gap: "0.75rem", alignItems: "flex-end" }}>
        <div style={{ flex: 1 }}>
          <SelectBox
            label="Category"
            options={categoryOptions}
            value={formData.category}
            onChange={(e) => handleChange("category", e.target.value)}
            error={errors.category}
            fullWidth
            required
          />
        </div>
        <Button
          type="button"
          variant="secondary"
          onClick={handleAddCategory}
          disabled={isCreatingCategory}
        >
          {isCreatingCategory ? "Adding..." : "Add Category"}
        </Button>
      </div>

      <TextField
        label="Date"
        type="date"
        value={formData.date}
        onChange={(e) => handleChange("date", e.target.value)}
        error={errors.date}
        fullWidth
        required
      />

      <div style={buttonGroupStyle}>
        <Button
          type="submit"
          variant="primary"
          disabled={isSubmitting}
          fullWidth
        >
          {isSubmitting ? "Submitting..." : submitLabel}
        </Button>
        {onCancel && (
          <Button
            type="button"
            variant="secondary"
            onClick={onCancel}
            disabled={isSubmitting}
          >
            Cancel
          </Button>
        )}
      </div>
    </form>
  );
}
