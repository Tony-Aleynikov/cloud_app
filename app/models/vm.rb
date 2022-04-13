class Vm < ApplicationRecord
    has_and_belongs_to_many :projects
    has_many :hdds
end
