class LoginService
  attr_reader :params, :session

  def initialize(params, session)
    @params, @session = params, session
  end

  def call
    check_password
    modify_session
    message
  end

  private
  def check_password; end
  def modify_session; end
  def message; end
end
