class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_for_admin
  
  def index
    @users = User.all
    @fooddrinks = Fooddrink.all
    @categories = FdType.all
  end

  def update_user
    user = User.find(params[:id])
    if user.has_role? :admin
      user.remove_role :admin
    else
      user.add_role :admin
    end
    
    redirect_to '/admin'
  end
  
  def destroy_user
    user = User.find(params[:id])
    rates = Rate.where(:rater_id => user.id)
    fooddrinks = Fooddrink.all
    user.destroy
    rates.delete_all
    
    fooddrinks.each do |fooddrink|
      Fooddrink.update_avg_qty(fooddrink)
      rating_cache = RatingCache.find_by(:cacheable_id => fooddrink.id)
      rating_cache.update_attributes(:avg => fooddrink.avg, :qty => fooddrink.qty) if rating_cache.presence
    end
    
    respond_to do |format|
      format.html { redirect_to admin_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def authorized_for_admin
    redirect_to root_url unless current_user.has_role? :admin
  end
  
end
