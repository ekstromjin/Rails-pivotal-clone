class PivotalMailer < ApplicationMailer
  def signup(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Pivotal Site', content_type: 'text/html')
  end
  def create_story(story)
    @story = story
    @story.users.each do |user|
      @user = user
      mail(to: @user.email, subject: 'A Story has been entrusted to you', content_type: 'text/html')
    end
  end
  def update_story(story, user)
    @story = story
    @user = user
    mail(to: @user.email, subject: 'You have becoming owner of this story')
  end
  def change_story_status(story)
    @admin = User.getAdmin
    @story = story
    mail(to: @admin.email, subject: 'Story status has been changed.')
  end
  def update_project(project, user)
    @project = project
    @user = user
    mail(to: @user.email, subject: 'This project wants you')
  end
  def create_comment(comment, story, user)
    @comment = comment
    @story = story
    @user = user
    mail(to: @user.email, subject: 'Someone commented this story')
  end
end
