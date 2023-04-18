require "rails_helper"
RSpec.describe School, type: :model do
  it 'title should present' do
    school = School.new(
      title: '',
      address: 'Indore',
      contact: "1234567890"
    )
    expect(school).to_not be_valid

    school.title = 'my school'
    expect(school).to be_valid
  end

  it 'address should present' do
    school = School.new(
      title: 'test',
      address: '',
      contact: "1234567890"
    )
    expect(school).to_not be_valid

    school.address = 'Indore'
    expect(school).to be_valid
  end

  it 'contact number should valid' do
    school = School.new(
      title: 'school 1',
      address: 'Indore',
      contact: "test"
    )
    expect(school).to_not be_valid

    school.contact = '1234567890'
    expect(school).to be_valid
  end

end
