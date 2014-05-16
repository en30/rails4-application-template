class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_for_twitter_oauth(request.env['omniauth.auth'], current_user)
    if @user.persisted?
      set_flash_message(:notice, :success, kind: 'Twitter')
      sign_in_and_redirect @user, :event => :authentication
    else
      failure
    end
  end

  def failure
    set_flash_message(:alert, :failure, reason: '', kind: 'Twitter')
    redirect_to root_path
  end
end
