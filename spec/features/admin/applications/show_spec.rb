require 'rails_helper'

RSpec.describe 'Admin Application show page' do

    before(:each) do
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
        @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
        @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
        @application_1 = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
            state: "WI", zip: 53144, description: "This is a description of why I'm a good fit.",
            application_status: "In Progress")
        @application_2 = Application.create!(name: 'Eric', street: "345 Street", city: "Denver",
            state: "CO", zip: 22387, description: "This is a better description of why I'm a good fit.",
            application_status: "In Progress")
        PetApplication.create(pet_id: @pet_1.id, application_id: @application_1.id)
        PetApplication.create(pet_id: @pet_1.id, application_id: @application_2.id)
            
    end
    it "can approve an application without affecting other applications for that pet" do

        visit "/admin/applications/#{@application_1.id}"
        
        click_button "Approve Babe's Adoption"
        
        visit "/admin/applications/#{@application_2.id}"
        expect(page).to have_content("Approve Babe's Adoption")
        expect(page).to have_content("Reject Babe's Adoption")
    end

    it "can reject an application without affecting other applications for that pet" do

        visit "/admin/applications/#{@application_1.id}"
        
        click_button "Reject Babe's Adoption"
        
        visit "/admin/applications/#{@application_2.id}"
        expect(page).to have_content("Approve Babe's Adoption")
        expect(page).to have_content("Reject Babe's Adoption")
    end

end