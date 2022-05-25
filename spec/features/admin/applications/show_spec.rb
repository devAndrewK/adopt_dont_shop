require 'rails_helper'

RSpec.describe 'the admin applications show page' do
    before(:each) do
        @application = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
            state: "WI", zip: 53144, application_status: "In Progress")
        @application_2 = Application.create!(name: 'Eric', street: "345 Street", city: "Denver",
            state: "CO", zip: 22387, application_status: "In Progress")
        @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter.id)
        @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: @shelter.id)
        @pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: @shelter.id)
    end
                
    it 'can approve a pet' do
                    
        visit "/applications/#{@application.id}"
        fill_in "Search", with: "Babe"
        click_button "Search"
        click_button "Adopt Babe"
        fill_in "Search", with: "elle"
        click_button "Search"
        click_button "Adopt Elle"
        fill_in "description", with: "This is a description."
        click_button "Submit"
            
        visit "/admin/applications/#{@application.id}"
            
        within "#pet-0" do
            expect(page).to have_button("Approve application for Babe")
            click_button "Approve application for Babe"
            expect(page).to_not have_button("Approve application for Babe")
            expect(page).to have_content("approved")
        end
            
        within "#pet-1" do
            expect(page).to have_button("Approve application for Elle")
            click_button "Approve application for Elle"
            expect(page).to_not have_button("Approve application for Elle")
            expect(page).to have_content("approved")
        end
    end
        
    it 'can reject a pet' do
            
        visit "/applications/#{@application.id}"
        fill_in "Search", with: "Babe"
        click_button "Search"
        click_button "Adopt Babe"
        fill_in "Search", with: "elle"
        click_button "Search"
        click_button "Adopt Elle"
        fill_in "description", with: "This is a description."
        click_button "Submit"
            
        visit "/admin/applications/#{@application.id}"
            
        within "#pet-0" do
            expect(page).to have_button("Reject application for Babe")
            click_button "Reject application for Babe"
            expect(page).to_not have_button("Approve application for Babe")
            expect(page).to_not have_button("Reject application for Babe")
            expect(page).to have_content("rejected")
        end
            
        within "#pet-1" do
            expect(page).to have_button("Reject application for Elle")
            click_button "Reject application for Elle"
            expect(page).to_not have_button("Approve application for Elle")
            expect(page).to_not have_button("Reject application for Elle")
            expect(page).to have_content("rejected")
        end
    end

    it "can approve an application without affecting other applications for that pet" do
        PetApplication.create(pet_id: @pet_2.id, application_id: @application.id)
        PetApplication.create(pet_id: @pet_2.id, application_id: @application_2.id)
        visit "/admin/applications/#{@application.id}"
        click_button "Approve application for Babe"
        
        visit "/admin/applications/#{@application_2.id}"

        expect(page).to have_button("Approve application for Babe")
        expect(page).to have_button("Reject application for Babe")
    end
        
    it "can reject an application without affecting other applications for that pet" do
        PetApplication.create(pet_id: @pet_2.id, application_id: @application.id)
        PetApplication.create(pet_id: @pet_2.id, application_id: @application_2.id)
        visit "/admin/applications/#{@application.id}"
            
        click_button "Reject application for Babe"
            
        visit "/admin/applications/#{@application_2.id}"
        expect(page).to have_button("Approve application for Babe")
        expect(page).to have_button("Reject application for Babe")
    end
end
    