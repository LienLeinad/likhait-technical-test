class Expense < ApplicationRecord
  belongs_to :category

  # Add expense validation to prevent future dates
  validates :date, presence: true
  validates :date, comparison: {
    less_than_or_equal_to: -> (_expense) { Date.current },
    message: "Cannot be in the future"
  }


end
