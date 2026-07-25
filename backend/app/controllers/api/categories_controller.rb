class Api::CategoriesController < ApplicationController
  def index
    categories = Category.order(:name)
    render json: categories
  end
  
  def create
    category = Category.new(category_params)    
    if category.save
      # Success
      render json: format_category(category), status: :created
    else
      # Fail
      render json: { errors: categories.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def format_category(category)
    {
      id: category.id,
      name: category.name,
      created_at: expense.created_at,
      updated_at: expense.updated_at,
    }
  end

  def category_params
    params.require(:category).permit(:name)
  end
end

