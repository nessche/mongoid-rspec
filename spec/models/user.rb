class User
  include Mongoid::Document

  field :login
  field :email
  field :role
  field :age, type: Integer
  field :password, type: String

  belongs_to :site, :inverse_of => :users
  has_many :articles, :foreign_key => :author_id
  has_many :comments, :dependent => :destroy, :autosave => true
  has_and_belongs_to_many :children, :class_name => "User"
  has_one :record

  embeds_one :profile

  validates :login, :presence => true, :uniqueness => { :scope => :site }, :format => { :with => /^[\w\-]+$/ }, :exclusion => { :in => ["super", "index", "edit"]}
  validates :email, :uniqueness => { :case_sensitive => false, :scope => :site, :message => "is already taken" }, :confirmation => true
  validates :role, :presence => true, :inclusion => { :in => ["admin", "moderator", "member"]}
  validates :profile, :presence => true, :associated => true
  validates :age, :presence => true, :numericality => true, :inclusion => { :in => 23..42 }, :on => [:create, :update]
  validates :password, :presence => true, :on => :create

  def admin?
    false
  end
end
