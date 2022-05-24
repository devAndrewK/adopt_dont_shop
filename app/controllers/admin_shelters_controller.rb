class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM Shelters ORDER BY Shelters.Name DESC")
    @pend_shelters = Shelter.joins(:applications).where("application_status = 'Pending'")
  end
end
