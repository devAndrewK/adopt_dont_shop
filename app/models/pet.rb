class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def has_status(id)
    if self.pet_applications.where("application_id = #{id}").empty?
      false
    else
      self.pet_applications.where("application_id = #{id}").first.status != nil
    end
  end

  def status(id)
    self.pet_applications.where("application_id = #{id}").first.status
  end
end
