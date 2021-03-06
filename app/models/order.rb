class Order < ApplicationRecord
    # before_validation :change_name
    # after_validation :do_something_on_update_or_create, on: [:update, :create]
    # before_create do
    #     self.name = name.capitalize
    # end
   
    # validates :name, presence: true

    # validates :name, length: { maximum: 10 } 
    # validates :cost, 
    #           inclusion: {
    #             in: 10..100_000,
    #             message: 'Cost %{value} should be more 10 parrots and below 100.000 parrots'
    #             },
    #             on: :create
    
    # validates :status,  
    #           inclusion: { in: [2], message: 'no such parrots' },
    #           if: [:status_changed?,:available_parrots?,:started?]

    before_update :calculated_price
    before_create :calculated_price
    
    scope :high_cost, -> { where(cost: 1_000..) }
    scope :vip_failed, -> { failed.high_cost }
    scope :created_before, -> (time) { where('created_at < ?, time')}

    enum status: %w[unavailable created started failed removed]
    # enum status: { unavailable: 0, created: 1, started: 2, failed: 3, removed: 4 }
    
    belongs_to :user
    has_and_belongs_to_many :tags
    has_and_belongs_to_many :networks

    private

    def available_parrots?
        user.ballance > cost
    end

    def calculated_price
      hdd_price = if options["hdd"]["hdd_type"] == "sas" 
                      options["hdd"]["hdd_capacity"].to_i * 300
                  elsif options["hdd"]["hdd_type"] == "sata"
                      options["hdd"]["hdd_capacity"].to_i * 200
                  elsif options["hdd"]["hdd_type"] == "ssd"
                      options["hdd"]["hdd_capacity"].to_i * 100
                  end
      price = options["cpu"].to_i * 1000 + (options["ram"].to_i)/1024 * 150 + hdd_price
      self.cost = price
    end

    # def change_name
    #     # Code to change name before validation
    # end

    # def do_something_on_update_or_create
    #     # Code to change something only on update action
    # end
end
