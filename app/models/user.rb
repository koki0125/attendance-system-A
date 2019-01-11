class User < ApplicationRecord
  # attendancesテーブルとの関連付け
  # userを削除した時、関連したデータを削除
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 } ,allow_nil: true
  # validates :basic_time, presence: true
  # validates :specified_working_time, presence: true
  
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
      
    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # csv_importに使われる
  # slice(ハッシュから指定した値だけを取り出す)
  # self.をつけるとクラスメソッド、ないとインスタンスメソッドになる
  def self.import(file)
    
    # 登録ユーザ配列
    new_users = []
    # 重複id
    overlap_id = []
    
    CSV.foreach(file.path, encoding: "Shift_JIS:UTF-8", headers: true) do |row|

      user = new(row.to_hash.slice(*updatable_attributes))
      # %i時のupdatable_attributesの値=>[:id, :name, :email, :department, :employee_number, :uid, :basic_time, :designated_start_time, :designated_finish_time, :superior, :admin, :password]
      # %w時のupdatable_attributesの値=>["id", "name", "email", "department", "employee_number", "uid", "basic_time", "designated_start_time", "designated_finish_time", "superior", "admin", "password"]
      new_users.push(user)
      # debuggerで確認して見てください。
    end
    
    new_users.each do |user|
      if !user.save
        return "id#{user.id}のデータ保存時にエラーが発生しました"
      end
    end
  end

  def self.updatable_attributes
    %w(id name email department employee_number uid basic_time designated_start_time designated_finish_time superior admin password)
    # %記法での定義で、配列の中身がシ��ボル（:nameみたいな形）になってました。シンボルと文字列は別物と解釈されるので、60行目のslice(*updatable_attributes)で、配列が認識されていませんでした。
    # 以下のサイトを参考に％記法を修正しました。
    # https://qiita.com/hkengo/items/6ceae8fb970ad4b17b53#w%E3%82%84i%E3%82%92%E4%BD%BF%E3%81%86
    # %i[id name email department employee_number uid basic_time designated_start_time designated_finish_time superior admin password]
  end
end

