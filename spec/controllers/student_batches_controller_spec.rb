require "rails_helper"
require 'shared_context'
RSpec.describe StudentBatchesController, type: :controller do
  let(:school){ School.create(title: "test school", address: "test", contact: "65465465452") }
  let(:user){ User.create(first_name: "aj", last_name: "test", email: "aj@yopmail.com", password: "123456QWEqww@", contact: "1236547890", school_id: school.id) }
  let(:user2){ User.create(first_name: "ajit", last_name: "test", email: "aj1@yopmail.com", password: "123456QWEqww@", contact: "1236547890", school_id: school.id) }
  
  let(:course){ Course.create(title: "st paul course 1", duration: "3 yrs", school_id: school.id, user_id: user.id) }
  let(:batch){ Batch.create(title: "st paul course 1 batch 2", start_date: "12-02-2023", school_id: school.id, user_id: user.id, course_id: course.id) }
  describe "GET /index" do
    it "list the student_batches records" do
      user.add_role "school admin"
      sign_in(user)
      student_batches_1 = StudentBatch.create(user_id: user.id, batch_id: batch.id)
      student_batches_2 = StudentBatch.create(user_id: user2.id, batch_id: batch.id)
      get :index, params: { batch_id: batch.id }
      expect(@controller.instance_variable_get(:@student_batches).first).to eq(student_batches_1)
      expect(@controller.instance_variable_get(:@student_batches).last).to eq(student_batches_2)
    end
  end

  describe "POST /create" do
    it "create enrollment requests" do
      user.add_role "student"
      sign_in(user)
      post :create, params: { batch_id: batch.id }
      expect(@controller.instance_variable_get(:@student_batch).status).to eq("requested")
    end
  end

  describe "PATCH /approve" do
    it "Approve enrollment requests" do
      user.add_role "school admin"
      sign_in(user)
      student_batch = StudentBatch.create(user_id: user2.id, batch_id: batch.id)
      
      patch :approve, params: { batch_id: batch.id, student_batch_id: student_batch.id }
      expect(@controller.instance_variable_get(:@student_batch).status).to eq("approved")
    end
  end

  describe "PATCH /deny" do
    it "Deny enrollment requests" do
      user.add_role "school admin"
      sign_in(user)
      student_batch = StudentBatch.create(user_id: user2.id, batch_id: batch.id)
      
      patch :deny, params: { batch_id: batch.id, student_batch_id: student_batch.id }
      expect(@controller.instance_variable_get(:@student_batch).status).to eq("denied")
    end
  end

  describe "get /classmates" do
    it "list classmates whom requests are approved" do
      user.add_role "student"
      sign_in(user)
      student_batch_1 = StudentBatch.create(user_id: user.id, batch_id: batch.id)
      student_batch_1.approved!

      student_batch_2 = StudentBatch.create(user_id: user2.id, batch_id: batch.id)
      student_batch_2.approved!

      get :classmates
      expect(@controller.instance_variable_get(:@student_batches).last).to eq(student_batch_2)
    end

    it "not list classmates whom requests are pending" do
      user.add_role "student"
      sign_in(user)
      sign_in(user)
      student_batch_1 = StudentBatch.create(user_id: user.id, batch_id: batch.id)
      student_batch_1.approved!

      student_batch_2 = StudentBatch.create(user_id: user2.id, batch_id: batch.id)

      get :classmates
      expect(@controller.instance_variable_get(:@student_batches).last).not_to eq(student_batch_2)
    end

  end
end
