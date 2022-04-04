class User < ApplicationRecord
    has_many :orders
    has_one :passport_data
end
