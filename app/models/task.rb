class Task < ApplicationRecord
  validates :position, presence: true, numericality: true, uniqueness: true
  validates :name, presence: true
  validates :description, presence: true
end
