require 'rails_helper'

RSpec.describe 'the application show' do
    it "shows the application and attributes" do
        application = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
        state: "WI", zip: 53144, application_status: "In Progress")

        visit "/applications/#{application.id}"

        expect(page).to have_content(application.name)
        expect(page).to have_content(application.street)
        expect(page).to have_content(application.city)
        expect(page).to have_content(application.state)
        expect(page).to have_content(application.zip)
        expect(page).to have_content(application.application_status)
    end

    it "can search for pets by name" do
        application = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
        state: "WI", zip: 53144, application_status: "In Progress")
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)


        visit "/applications/#{application.id}"

        expect(page).to have_content("Add a Pet to this Application")
        expect(page).to have_button("Search")
        fill_in "Search", with: "Babe"
        click_button "Search"
        expect(current_path).to eq("/applications/#{application.id}")
        expect(page).to have_content("Babe")
    end


    it "can add a pet to an application" do
        application = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
        state: "WI", zip: 53144, application_status: "In Progress")
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)


        visit "/applications/#{application.id}"

        expect(page).to_not have_content("Submit")
        expect(page).to_not have_content("Please tell us why you would make an excellent candidate for adoption.")
        fill_in "Search", with: "Babe"
        click_button "Search"

        click_button "Adopt Babe"

        expect(current_path).to eq("/applications/#{application.id}")
        expect(page).to have_link("Babe", href: "/pets/#{pet_2.id}")
    end

    it 'can submit an application' do
        application = Application.create!(name: 'Andrew', street: "123 Street", city: "Kenosha",
        state: "WI", zip: 53144, application_status: "In Progress")
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
        visit "/applications/#{application.id}"

        fill_in "Search", with: "Babe"
        click_button "Search"
        click_button "Adopt Babe"
        expect(page).to_not have_content("Adopt Babe")
        fill_in "description", with: "This is a description."
        click_button "Submit"

        expect(current_path).to eq("/applications/#{application.id}")
        expect(page).to have_content("Application Status: Pending")
        save_and_open_page
        expect(page).to have_content("Babe")
        expect(page).to have_content("This is a description")
        expect(page).to_not have_content("Add a Pet to this Application")
    end

end
