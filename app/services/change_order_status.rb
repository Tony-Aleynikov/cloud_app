class ChangeOrderStatus
  def self.call(data)
    # Faraday.get("http://localhost:3000/orders/status", #{ order_id: <id>, status: <status> }
    Faraday.get("http://app:3000/orders/status",
  {
    order_id: data["odred_id"],
    status:   data["status"]
  }
)
  end
end
