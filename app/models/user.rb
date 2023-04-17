class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :school

  validates :first_name, :last_name, :email, :contact, presence: true
  validates_format_of :contact, :with =>  /\d[0-9]\)*\z/ , :message => "Only positive number without spaces are allowed"
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }


  ROLES = ["admin", "school admin", "student"].freeze
  attr_accessor :role
  
  after_save :update_role
  after_create :send_password

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def role_name
    # considering single role per user
    roles.first.try(:name).try(:titleize) || "NA"
  end

  def admin?
    role_name == "Admin"
  end

  def school_admin?
    role_name == "School Admin"
  end

  def student?
    role_name == "Student"
  end

  def set_password
    SecureRandom.hex(8)
  end

  private

  def update_role
    # add new role and remove old roles
    return if role == role_name
    if role.present? && ROLES.include?(role)
      roles.destroy_all 
      add_role role
    end
  end

  def password_required?
    # devise's method changed
    return false if new_record?
    super
  end

  def send_password
    pass = SecureRandom.hex(6)
    update(password: pass)
    UserMailer.send_password(self, pass).deliver_now
  end
end
  