class CheckOrderService

  def self.check(params)
    response   = get_data #2 получаем список возможных конфигураций
    equipments = JSON.parse(response.body)["specs"]
    conformity_check(equipments, params) #3 проверка соответсвия
  end

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

  def self.call(params, session)
    if CheckOrderService.check(params) != true
      return { result: { result: false, error: "Некорректная конфигурация" }, status: status: 406 }
    end

    price = CheckOrderService.get_price(params)            #4 запрашиваем цену у сервиса
    balance_after_transaction = session[:balance] - price  #5 проверяем, достаточно ли средств у пользователя

    if balance_after_transaction >= 0                      #6 возвращаем статус и json
      session[:balance] -= price
      { result: { result: true,
                  total: price,
                  balance: session[:balance] ,
                  balance_after_transaction: balance_after_transaction
                }, status: 200 }
    else
      { result: { result: false,
                  error: "Недостаточно средств"
                }, status: status: 406 }
    end

  rescue Faraday::Error
    { result: { result: false,
                error: "Ошибка доступа к внешней системе"
              }, status: status: 503 }
  end

end
