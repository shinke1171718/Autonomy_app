class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :name, presence: { message: "ユーザー名は必須です" },
    length: { maximum: 8, too_long: "ユーザー名は最大%{count}文字までです" }

  validates :email, presence: { message: "メールアドレスは必須です" },
    uniqueness: { case_sensitive: false, message: "このメールアドレスは既に使用されています" },
    length: { maximum: 254, too_long: "メールアドレスは最大%{count}文字までです" }

  # パスワードのバリデーションを新規作成と更新の両方で適用
  # パスワードが変更された場合、または新規作成の場合に検証する

  validates :password, presence: { message: "新しいパスワードは必須です" },
    length: { minimum: 8, too_short: "パスワードは最低%{count}文字必要です" }, if: :password_present?

  validates :password, confirmation: { message: "パスワードと確認用パスワードが一致しません" },
    format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: "パスワードは英数字を含む必要があります" }, if: :password_present?

  validates :password_confirmation, presence: { message: "確認用パスワードの入力は必須です" }, if: :password_present?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessor :current_password

  has_many :menu_users, dependent: :destroy
  has_many :menus, through: :menu_users
  has_one :cart, dependent: :destroy
  has_many :completed_menus, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :completed_menus, dependent: :destroy

  private

  # def current_password_is_correct
  #   if !valid_password?(current_password)
  #     errors.add(:current_password, '現在のパスワードが正しくありません')
  #   end
  # end

  def password_present?
    password.present?
  end
end
