require 'rails_helper'

RSpec.describe "Api::Expenses", type: :request do
  let!(:food_category) { Category.find_or_create_by!(name: "Food") }
  let!(:transport_category) { Category.find_or_create_by!(name: "Transport") }

  describe "GET /api/expenses" do
  let!(:expense1) { Expense.create!(description: "Lunch", amount: 100.00, category: food_category, date: Date.today) }
  let!(:expense2) { Expense.create!(description: "Taxi", amount: 50.00, category: transport_category, date: Date.today) }
  let!(:expense_newer) { Expense.create!(description: "New Expense", amount: 123.45, category: food_category, date: Date.new(2026,2,10))}
  let!(:expense_older) { Expense.create!(description: "Older Expense", amount: 123.45, category:food_category, date: Date.new(2026,1,10))}

    it "returns all expenses with category information" do
      get "/api/expenses"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(4)
    end

    it "returns expenses in descending order by date" do
      get "/api/expenses"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(4)

      expected_dates = [
        expense1.date.to_s,
        expense2.date.to_s,
        expense_newer.date.to_s,
        expense_older.date.to_s
      ]

      expect(json.map { |expense| expense["date"] }).to eq(expected_dates)
    end
  end

  describe "POST /api/expenses" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          expense: {
            description: "Team Lunch",
            amount: 150.50,
            category_id: food_category.id,
            date: Date.today
          }
        }
      end

      it "creates a new expense" do
        expect {
          post "/api/expenses", params: valid_params, as: :json
        }.to change(Expense, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["description"]).to eq("Team Lunch")
        expect(json["amount"]).to eq(150.5)
      end
    end

    context "with invalid parameters" do
      it "rejects a future date" do
        invalid_params = {
          expense: {
            description: "Future expense",
            amount: 100.00,
            category_id: food_category.id,
            date: Date.tomorrow
          }
        }

        expect {
          post "/api/expenses", params: invalid_params, as: :json
        }.not_to change(Expense, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Date cannot be in the future")
      end

      it "rejects an empty description" do
        invalid_params = {
          expense: {
            description: "",
            amount: 100.00,
            category_id: food_category.id,
            date: Date.today
          }
        }

        expect {
          post "/api/expenses", params: invalid_params, as: :json
        }.not_to change(Expense, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
