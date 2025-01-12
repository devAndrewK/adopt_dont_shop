class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.show_pets
  end

  def update
    @application = Application.find(params[:id])
    pet_application = PetApplication.where("pet_id = #{params[:pet_id]}").where("application_id = #{@application.id}")
    if params[:status]
      pet_application.update(status: params[:status])
    end
    redirect_to "/admin/applications/#{@application.id}"
  end
end
