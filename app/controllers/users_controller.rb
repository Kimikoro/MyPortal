class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:finish_signup, :top]

	# OAuth認証による新規登録の締めを司るアクション。
  # ユーザーデータを更新に成功したら、email確認メールを送付する。
  # GET   /users/:id/finish_signup - 必要データの入力を求める。
  # PATCH /users/:id/finish_signup - ユーザーデータを更新。
  def finish_signup
    @user = User.find(params[:id])
    if request.patch? && @user.update(user_params)
      @user.send_confirmation_instructions unless @user.confirmed?
      flash[:info] = 'We sent you a confirmation email. Please find a confirmation link.'
      redirect_to root_path
    end
  end


	def top
	end

	private

    # user_paramsにアクセスするため。
    def user_params
      accessible = [ :username, :email ]
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
