class UsersController < ApplicationController

before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
# definition for signed_in_user (which redirects to sign-in page if not signed in) is in sessions_helper.rb
before_filter :correct_user,   only: [:edit, :update]
before_filter :admin_user,     only: :destroy

 def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # pagination replacement for @microposts = @user.microposts.all  (see analog in show index below)
    #params means parameters of the request.  E.g., when clicking on a link for a particular user (say, 5) from 
    # the index page, a request is sent to that user_path(5) URI, along with params of that request -
    # i guess the :id paramater is the id for the requested users page (id = 5).  Then @user is set to user #5 here.  
    #Then the requested page is rendered 'show.html.erb', with, e.g., a title with content name of user 5 (name of @user)
    # When the current user (visiting user 5's profile) then hits 'follow,' a POST request is sent to relationships_path
    #(set by resources :relationships in config/routes), which hits the create action (to be found by default in the 
    # 'Relationships Controller').  I guess Rails knows we're using the create action for the relationships model b/c
    # of the form_for underlying the follow button, which references a relationship object. That form builds a relationship
    # for the current_user and sets followed_id for the relationship to @user.id - since that form is rendered via this
    #show action, @user is still user #5, and followed_id is set to 5. Then when the form submits, the hidden field
    # passes on (via params of this request) the followed_id (which is 5) to the create action in the Relationships controller. 
    # The create action, as defined, then finds the user with that followed_id (using a hash of hashes - asks for the 
    # value corresponding to the :relationships key in the params hash, that value itself being a hash of key-value pairs,
    # and then asks for the value corresponding to the :followed_id key in that value/hash, which in this case is 5).
    # This relationships controller create action then sets @user to that user (again, user #5). It then makes the current_user
    # follow! this @user, which is what we wanted to accomplish with the follow button.  The create action then redirects to 
    # @user's (in this case, user #5) profile page.

    #correction:  I think the form_for rendered by the show page builds a temporary relationship, with followed_id assigned,
    #for the sake of creating the form.  Then the create action hit upon submitting the form actually builds the new
    #relationship (via follow!).
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
    @user = User.new(params[:user])  #what is this really doing?
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


def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    #this uses the has many followed_users association set in user.rb (retruns all associated followed_users)
    render 'show_follow'
    # I think the explicit call to render is necessary because we are using the same show_follow 
    #page for both following and followers actions, rather than the default follow.html.erb page?  Yes.  We could instead include a 
    #view called 'following.html.erb' that would automatically be rendered
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    # this uses the has many followers association set in user.rb (returns all associated followers)
    render 'show_follow'
  end


private

=begin 
   def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
=end #removed bc code moved to sessions helper. Is code in any helper available to all controllers?
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end
