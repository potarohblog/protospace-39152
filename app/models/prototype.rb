class Prototype < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  # dependent:は削除したプロトタイプに紐づくコメントも削除を行うために記述

  validates :title, presence: true
  validates :catch_copy, presence: true
  validates :concept, presence: true  
  validates :image, presence: true
end
