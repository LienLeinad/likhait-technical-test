class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy

  #Add category validation to prevent nil and non characters
  validates :name, presence: true
  validates :name, format: {
    with: /\A[[:alpha:][:space:]-]+\z/,
    message: "can only contain letters, spaces, and hyphens"
  }
end
