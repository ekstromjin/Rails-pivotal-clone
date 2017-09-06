class AwardController < ApplicationController
  def create
    award_params = {
        points: params[:points],
        story_id: params[:story_id],
        user_id: session[:user_id],
    }

    @award = Award.new(award_params)
    @award.save()
  end
end
