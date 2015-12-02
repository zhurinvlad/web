class Product < ActiveRecord::Base
	validates :title, :description, :image_url, :price, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, allow_blank: true, presence: true, uniqueness: { message: "значение не уникально"  }
	validates :title, allow_blank: true, length: { minimum: 3, message: ": не может быть меньше 3 символов."  }
	validates :image_url, allow_blank: true, format: {
	    with: %r{\.(gif|jpg|png)\Z}i,
	    message: ': URL должен указывать на изображение формата GIF, JPG или PNG.'
	}
	def self.latest
  		Product.order(:updated_at).last
	end
    has_many :orders, through: :line_items
	has_many :line_items
    before_destroy :ensure_not_referenced_by_any_line_item
    private
    # убеждаемся в отсутствии товарных позиций, ссылающихся на данный товар
    def ensure_not_referenced_by_any_line_item
        if line_items.empty?
            return true
        else
            errors.add(:base, 'существуют товарные позиции')
            return false
        end
    end
    
end
