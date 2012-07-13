class UsersController < ApplicationController

before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
before_filter :correct_user,   only: [:edit, :update]
before_filter :admin_user,     only: :destroy

 def show
    @user = User.find(params[:id])
  end

 # def new
  #  @user = User.new
 # end

 def new
  if signed_in?
   redirect_to root_path  
  else
  @user = User.new  
  end
end

=begin
  def create
    @user = User.new(params[:user])
    if @user.save  #???this is what saves the user upon clicking the submit button (in the
      # 'new' page and thereby submitting a post request (executing the create action)
      # - that is, @user.save is a command? which if successful returns true?  or is 
      # the user automatically saved by the post request (if validations pass)?  
      # it seems like (From section 9.1.2) that the if @user.save actually attempst the save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # --same as-- redirect_to user_path(@user)
    else
      render 'new'
    end
  end
=end


def create
  if signed_in?
    redirect_to root_path
  else
    @user = User.new(params[:user])
    if @user.save  #???this is what saves the user upon clicking the submit button (in the
      # 'new' page and thereby submitting a post request (executing the create action)
      # - that is, @user.save is a command? which if successful returns true?  or is 
      # the user automatically saved by the post request (if validations pass)?  
      # it seems like (From section 9.1.2) that the if @user.save actually attempst the save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # --same as-- redirect_to user_path(@user)
    else
      render 'new'
    end
  end
end


  def edit
   # @user = User.find(params[:id])
  end

  def update
     # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end 

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end

=begin
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
=end

  def destroy
    if current_user == User.find(params[:id])
      redirect_to root_path
    else
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
    end
  end

private

   def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end
