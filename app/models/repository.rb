class Repository < ApplicationRecord
  has_many_attached :docs
  has_one_attached :archive
end
