class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :name, presence: { message: "ユーザー名は必須です。" },
  length: { minimum: 8, too_short: "ユーザー名は最小%{count}文字必要です。", maximum: 30, too_long: "ユーザー名は最大%{count}文字までです。" },
  format: { with: /\A[a-zA-Z0-9_\u3040-\u30FF\u3400-\u4DBF\u4E00-\u9FFF]+\z/, message: "英数字、アンダースコア、日本語のみ使用できます。" }, if: :user_info_change_or_new_record?

  # メールアドレスのバリデーション
  validates :email, presence: { message: "メールアドレスは必須です" },
    uniqueness: { case_sensitive: false, message: "このメールアドレスは既に使用されています。" },
    length: { maximum: 254, too_long: "メールアドレスは最大%{count}文字までです。" },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/, message: "メールアドレスの形式が不正です" }, if: :email_change_or_new_record?

  # パスワードのバリデーションを新規作成と更新の両方で適用
  # パスワードが変更された場合、または新規作成の場合に検証する
  validates :password, length: { minimum: 8, too_short: "パスワードは最低%{count}文字必要です。" }, if: :password_change_or_new_record?
  validates :password, confirmation: { message: "新しいパスワードと確認用パスワードが一致しません。" },
    format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_])[a-zA-Z\d\W_]+\z/, message: "パスワードは8文字以上、大小英字、数字、記号を含んでください。" }, if: :password_change_or_new_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  attr_accessor :current_password, :user_info_change, :password_change, :new_record, :email_change

  has_many :menu_users, dependent: :destroy
  has_many :menus, through: :menu_users
  has_one :cart, dependent: :destroy
  has_many :completed_menus, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :completed_menus, dependent: :destroy

  private

  # ユーザー名更新or新規登録の場合にバリデーションを行うための設定
  def user_info_change_or_new_record?
    user_info_change || new_record
  end

  # メールアドレス更新or新規登録の場合にバリデーションを行うための設定
  def email_change_or_new_record?
    email_change || new_record
  end

  # パスワード更新or新規登録の場合にバリデーションを行うための設定
  def password_change_or_new_record?
    password_change || new_record
  end
end
