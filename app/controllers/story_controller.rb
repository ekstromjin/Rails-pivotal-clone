class StoryController < ApplicationController
  before_action :set_panel_options, only: [:create, :change_status, :set_points]

  def create
    @story_create_params = story_params
    @memberIds = story_params[:members].split(',')
    @story_create_params.delete(:members);

    @project = Project.find(story_params[:project_id])
    @story = Story.new(@story_create_params)
    @story[:status] = 0
    @story.save

    @story.users = User.where(id: @memberIds)

    @story = Story.find(@story[:id])
    PivotalMailer.create_story(@story).deliver_later
  end

  def update
    @story_update_params = update_params
    @memberIds = update_params[:members].split(',').map {|memberid| memberid.to_i }
    @story_update_params.delete(:members)
    @story_update_params.delete(:story_id)
    if @story_update_params[:points].to_i == 0
      @story_update_params[:award_began] = 0
    end

    puts 'stroy_update'
    puts @story_update_params

    @story = Story.find(update_params[:story_id])
    @project = @story.project
    @story.update(@story_update_params)

    if @story_update_params[:points] == 0
      @story.awards.destroy_all
    end

    @add_members = @memberIds - @story.getOwnerIds
    @story.users = User.where(id: @memberIds)

    User.where(id: @add_members).each {|user| PivotalMailer.update_story(@story, user).deliver_later }
  end

  def update_title
    @story = Story.find(update_title_params[:id])
    @story.update(update_title_params)
  end

  def update_description
    @story = Story.find(update_description_params[:id])
    @story.update(update_description_params)
  end

  def change_status
    @project = Project.find(params[:project_id])
    @story = Story.find(params[:id])
    @story[:status] = params[:status]
    @story.save

    PivotalMailer.change_story_status(@story).deliver_later
  end

  def set_award
    @story = Story.find(params[:story_id])
    @story[:award_began] = 1
    @story.save
    @project = @story.project
  end

  def set_points
    @story = Story.find(params[:story_id])
    @story.points = params[:points]
    @story[:award_began] = 0
    @story.save
    @story.awards.destroy_all
    @project = @story.project
  end

  def delete
    @story = Story.find(params[:id])
    @project = @story.project
    @story.destroy
  end

  private
    def set_panel_options
      default_panel_options = [
          {"panel_type" => 'my_work', "is_visible" => true},
          {"panel_type" => 'current', "is_visible" => true},
          {"panel_type" => 'backlog', "is_visible" => true},
          {"panel_type" => 'test', "is_visible" => true},
          {"panel_type" => 'done', "is_visible" => true}
      ]

      @panel_options = cookies[:panel_options].present? ? JSON.parse(cookies[:panel_options]) : default_panel_options
    end
    def story_params
      params.require(:story).permit(:title, :story_type, :project_id, :points, :description, :members )
    end
    def update_params
      params.require(:story).permit(:story_id, :story_type, :points, :members )
    end
    def update_title_params
      params.require(:story).permit(:id, :title )
    end
    def update_description_params
      params.require(:story).permit(:id, :description )
    end
end
