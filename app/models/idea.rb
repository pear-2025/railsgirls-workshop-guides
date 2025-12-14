class Idea < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  mount_uploader :picture, PictureUploader

  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  def deadline_color
    return nil unless date.present?
    
    days_until_deadline = (date - Date.today).to_i
    
    if days_until_deadline <= 1
      'rgba(255, 100, 100, 0.2)' # 薄い赤
    elsif days_until_deadline <= 3
      'rgba(255, 255, 100, 0.2)' # 薄い黄色
    else
      nil
    end
  end

  # `tags`カラムを配列のように扱えるようにします
  def tag_list
    tags.to_s.split(',')
  end

  # フォームから送られてきたカンマ区切りの文字列を`tags`カラムに保存します
  def tag_list=(tags_string)
    self.tags = tags_string
  end

end
