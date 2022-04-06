class User < ApplicationRecord
    #validates :first_name, format: { with: /\A[A-Z]\w{2,}/ }
    #validates :last_name, format: { with: /\A[A-Z]\w{2,}/ }
#если у меня несколько валидаций на одно поле, сработают все или первая?
    scope :length_name, -> { where('length(first_name) > 5 AND length(last_name) < 6')}
    has_many :orders
    has_one :passport_data
end
