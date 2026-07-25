require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:category) { Category.find_or_create_by!(name: "Food") }

  it "is invalid when the date is in the future" do
    expense = Expense.new(description: "Lunch", amount: 10.0, category: category, date: Date.tomorrow)

    expect(expense).not_to be_valid
    expect(expense.errors[:date]).to include("Cannot be in the future")
  end

  it "is valid when the date is today or in the past" do
    expense = Expense.new(description: "Lunch", amount: 10.0, category: category, date: Date.today)

    expect(expense).to be_valid
  end
end
