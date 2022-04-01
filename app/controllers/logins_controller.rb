class LoginsController < ApplicationController
  skip_before_action :check_aut
  
  def show
  end

  def create
    if params[:password] == '123'
      session[:login] = params[:login]
      session[:balance] ||= 1000 

      notice_message =  case Time.now.hour 
          when 0..5 
            'Доброй ночи, ' 
          when 6..11 
            'С добрым утром, ' 
          when 12..17 
            'Добрый день, ' 
          when 18..24 
            'Добрый вечер, ' 
          else 
            'Здравствуйте, ' 
          end + params[:login]

      redirect_to :login, notice: notice_message 
    else
      redirect_to :login, notice: 'Неверный пароль'
    end
  end

  def destroy
    session.delete(:login)
    redirect_to :login, notice: 'Вы вышли'
  end
end
