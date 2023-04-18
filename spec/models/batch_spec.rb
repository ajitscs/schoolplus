require "rails_helper"
RSpec.describe Batch, type: :model do
  let(:school){ School.create(title: "test school", address: "test", contact: "65465465452") }
  let(:user){ User.create(first_name: "aj", last_name: "test", email: "aj@yopmail.com", password: "123456QWEqww@", contact: "1236547890", school_id: school.id) }
  let(:course){ Course.create(title: "st paul course 1", duration: "3 yrs", school_id: school.id, user_id: user.id) }
  
  it 'title should present' do
    batch = Batch.new(
      title: '',
      start_date: '12-02-2023',
      user_id: user.id,
      course_id: course.id,
      school_id: school.id
    )
    expect(batch).to_not be_valid

    batch.update(title: 'my batch')
    expect(batch).to be_valid
  end

  it 'start_date should present' do
    batch = Batch.new(
      title: 'test',
      start_date: '',
      user_id: user.id,
      course_id: course.id,
      school_id: school.id
    )
    expect(batch).to_not be_valid

    batch.update(start_date: '12-02-2023')
    expect(batch).to be_valid
  end

end
