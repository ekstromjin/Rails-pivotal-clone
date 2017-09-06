class Story < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :project
  has_many :tasks, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :relation_user_stories, :dependent => :destroy
  has_many :awards, :dependent => :destroy
  has_and_belongs_to_many(
      :users,
      :join_table => 'relation_user_stories',
      :foreign_key => "story_id",
      :association_foreign_key => "user_id"
  )

  def getOwnerIds
    users(true).map {|user| user.id}
  end

  def getOwnerNames
    users(true).map {|user| user.short_name}.join(', ')
  end

  def getOwnerFullnames
    users(true).map {|user| user.full_name}.join(', ')
  end

  def isTasksComplete
    tasks.length == tasks.where(status: 1).length
  end

  class << self
    def getUnestimatedStories
      where(points: 0)
    end

    def getBeganAwardStory
      find_by_award_began(1)
    end
  end
end
