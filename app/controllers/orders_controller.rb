class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :hw6, only: [:check]
  rescue_from NotAuthorized, { with: :hw6_1 }
  skip_before_action :verify_authenticity_token
  skip_before_action :check_aut, only: [:check]
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

  def check
    result = CheckOrderService.call(params, session)

    render json: result["result"], result["status"]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:name, :status, :cost)
    end

    def hw6
      if session[:balance] == nil || session[:login] == nil
        raise NotAuthorized
      end
    end

    def hw6_1
      render json: { result: false,
                              error: "В текущей сессии нет имени пользователя или баланса"
                            }, status: 401
    end
end
