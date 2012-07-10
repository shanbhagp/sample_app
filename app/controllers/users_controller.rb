class UsersController < ApplicationController
 def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save  #???this is what saves the user upon clicking the submit button (in the
      # 'new' page and thereby submitting a post request (executing the create action)
      # - that is, @user.save is a command? which if successful returns true?
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # --same as-- redirect_to user_path(@user)
    else
      render 'new'
    end
  end

end
