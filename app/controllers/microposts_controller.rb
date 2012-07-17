class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
      #redirect_to root_path  - this works without assigning @feed_items
      # but to directlty render 'static_pages/home', we need to set the instance variable @feed_items again 
      # (i guess the instance variable isn't inherited from the def home in static pages controller)
      # the home page html requires something for the @feed_items instance variable, so we set it to
      # an empty array, and then (as expected) the re-rendered hompage lacks a feed.
      # Notice that with redirect_to root_path, no error message appears for the failed post attempt:
      # The flash message requires the failed save attempt (right?) under def create, which then gets
      #directly passed to the re-rendering of the home page; if we instead re-direct to root_path, we
      # simply go through the home action in the Static pages controller and render the homepage withouth the 
      # benefit of any error message being passed (I guess it's lost upon executing a fresh action (the home action in SPC)) 
      # (and the @feed_items instance variable is re-set)
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end


end
