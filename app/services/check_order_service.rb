class CheckOrderService
  def self.get_data
    Faraday.get('http://possible_orders.srv.w55.ru/')
  end

  def self.conformity_check(equipments, params)
    equipments.any? do |equipment|
      equipment["os"].include?(params["os"]) &&
        equipment["cpu"].include?(params["cpu"].to_i) &&
        equipment["ram"].include?(params["ram"].to_i) &&
        equipment["hdd_type"].include?(params["hdd_type"]) &&
        equipment["hdd_capacity"]["#{params["hdd_type"]}"]["from"].to_i <= params["hdd_capacity"].to_i &&
        equipment["hdd_capacity"]["#{params["hdd_type"]}"]["to"].to_i >= params["hdd_capacity"].to_i
    end
  end

  def self.get_price(params)
    price = Faraday.get( "http://calculation_service:3005/price",
      {
       cpu:          params[:cpu],
       ram:          params[:ram],
       hdd_type:     params[:hdd_type],
       hdd_capacity: params[:hdd_capacity]
      }
    )
    price = price.body.to_i
  end
end
