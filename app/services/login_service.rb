class LoginService
  attr_reader :params, :session

  def initialize(params, session)
    @params, @session = params, session
  end

  def call
    if check_password
      modify_session
    end
    message
  end

  private
  def check_password
    @params[:password] == "123"
  end
  
  def modify_session
    session[:login] = params[:login]
    session[:balance] ||= 1000 
  end

  def message
    if check_password
      case Time.now.hour 
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
    else
      'Неверный пароль'
    end
  end
end
