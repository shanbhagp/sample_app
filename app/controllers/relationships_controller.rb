class RelationshipsController < ApplicationController
  before_filter :signed_in_user

=begin
#  action definitions when not using Ajax for follow/unfollow buttons

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end
  # see Users controller notes for an explanation of what's going on here

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end
  # the parameters of the request hitting this action come from the submission of the form in the _unfollow partial.
  # code there is for_form(current_user.relationships.find_by_followed_id(@user).  This means form_for the relationship belonging to 
  # current_user which has the followed_id = @user as set in the show action, which (in the example in my user controller notes)
  # is user #5. Question: @user at this point is supposed to be a user, not a user id.  would we say find_by_followed_id(@user.id)?
  # Answer?: (Here we’ve used the Rails convention of user instead of user.id in the condition; Rails automatically uses the id.)
  # anyway, so the parameters of the DELETE request from submitting that form is the information associated with that relationship (say,
    # with ID = 31).  The DELETE request takes those parameters and hits this destroy action, which finds the relationship with that ID
  # (31), returns the user whose ID is the followed_id for this relationship ( via the 'relationship belongs_to followed' association
  #  set in the Relationships model, which tells Rails that a relationship belongs to a user (b/c of class name User) given by the
  # foreign key followed_id = id of that user (rather than user_id = id of that user)), ands sets @user to that user (which is user #5).
  # note that the Relationship model (and this belongs_to association) allows that a relationship will respond to 'followed' (as in
    # somerelationship.followed), as required in the relationship specs. 




=end

# using Ajax for follow/unfollow buttons
def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end



end