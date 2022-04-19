class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  # GET /orders or /orders.json
  def index
    # @orders = Order.all
    params["page"] == nil ? page = 1 : page = params["page"].to_i
    params["per_page"] == nil ? per_page = 30 : per_page = params["per_page"].to_i

    @orders = Order.limit(per_page).offset((page-1)*per_page).order('id DESC')

    #  @orders = []
    #  Order.all.each do |order|
    #   #Order.eager_load(:networks,:tags)
    #    @orders << {
    #      name: order.name,
    #      created_at: order.created_at,
    #      networks_count: order.networks.length,
    #      tags: order.tags.map {|tag| {id: tag.id, name: tag.name}}
    #    }
    #  end

    #  render json: { orders: @orders }
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def approve
    render json: params
  end

  def calc
    render plain: "#{rand(0..100)}"
  end

  def first
    @order = Order.first
    render :show
  end

  def status
    order = Order.find(params["order_id"].to_i)
    order.update(status: params["status"])
    render plain: "success"
  end

  # def check
  #   # byebug
  #   response = Faraday.get('http://possible_orders.srv.w55.ru/')
  #   equipments = JSON.parse(response.body)["specs"]

  #   result = equipments.any? do |equipment|
  #     equipment["os"].include?(params["os"]) &&
  #       equipment["cpu"].include?(params["cpu"].to_i) &&
  #       equipment["ram"].include?(params["ram"].to_i) &&
  #       equipment["hdd_type"].include?(params["hdd_type"]) &&
  #       equipment["hdd_capacity"]["#{params["hdd_type"]}"]["from"].to_i <= params["hdd_capacity"].to_i &&
  #       equipment["hdd_capacity"]["#{params["hdd_type"]}"]["to"].to_i >= params["hdd_capacity"].to_i
  #   end

  #   price = Faraday.get( "http://127.0.0.1:3005/price",
  #     {
  #      cpu:          params[:cpu],
  #      ram:          params[:ram],
  #      hdd_type:     params[:hdd_type],
  #      hdd_capacity: params[:hdd_capacity]
  #     }
  #   )
  #   # price = price.body.to_i
  #   # render plain: equipments
  #   # render plain: params
  #   # render plain: result
  #   # render plain: price

  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:name, :status, :cost)
    end

end
