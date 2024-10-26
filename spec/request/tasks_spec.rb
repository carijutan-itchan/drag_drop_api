require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do

  let!(:tasks) do
    [
      Task.create!(name: 'Test Name 1', description: 'Test Description 1', position: 30000),
      Task.create!(name: 'TTest Name 2', description: 'Test Description 2', position: 30001),
      Task.create!(name: 'Test Name 3', description: 'Test Description 3', position: 30002),
      Task.create!(name: 'Test Name 4', description: 'Test Description 4', position: 30003),
      Task.create!(name: 'TTest Name 5', description: 'Test Description 5', position: 30004),
      Task.create!(name: 'Test Name 6', description: 'Test Description 6', position: 30005)
    ]
  end

  describe 'GET /tasks' do
    it 'returns all tasks' do
      get tasks_path

      expect(response).to have_http_status(:success)
      json_res = JSON.parse(response.body)

      expect(json_res.size).to eq(6)
      expect(json_res[0]['position']).to eq('30000.0')
      expect(json_res[1]['position']).to eq('30001.0')
    end
  end

  describe 'POST /tasks' do
    let(:tasks_params) do
       {
        task: {
          name: 'New Test Task',
          description: 'Task Test description',
          position: 30006
        }
       }
    end

    context 'when the parameters is valid' do
      it 'can creates a task' do
        post tasks_path, params: tasks_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq('New Test Task')
      end
    end

    context 'when the parameters is invalid' do
      it 'returns 422 status code' do
        post tasks_path, params: { task: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe 'PUT /tasks/:id' do
    let(:tasks_params) do
       {
         task: { name: 'Updated Test Task' }
       }
    end

    context 'when the task exists' do
      it 'updates the task' do
        put task_path(tasks.first.id), params: tasks_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['name']).to eq('Updated Test Task')
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found message' do
        put task_path(1234), params: tasks_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    context 'when the task exists' do
      it 'deletes the task' do
        delete task_path(tasks.last.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found message' do
        delete task_path(1234)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /tasks/reorder' do
    context 'when parameter is valid' do
      context 'when task change its position goint to start of the TODO list' do
        let(:reorder_params) do
          {
            reorder: [
              {id: tasks[4].id, target_task_position: tasks[0].position, above_task_position: nil}
            ]
          }
        end

        it 'change the task position to start of the TODO list' do
          post reorder_tasks_path, params: reorder_params

          expect(response).to have_http_status(:ok)
          json_res = JSON.parse(response.body)

          expect(json_res["reordred_tasks"][0]["position"]).to eq(Task.order(:position).first.position.to_s)
        end
      end

      context 'when task change its position' do
        let(:reorder_params) do
          {
            reorder: [
              {id: tasks[5].id, target_task_position: tasks[1].position, above_task_position: tasks[0].position}
            ]
          }
        end

        it 'change the task position to start of the TODO list' do
          post reorder_tasks_path, params: reorder_params

          expect(response).to have_http_status(:ok)
          json_res = JSON.parse(response.body)

          expect(json_res["reordred_tasks"][0]["position"]).to eq(Task.order(:position).second.position.to_s)
        end
      end

      context 'when multiple task change its position' do
        let(:reorder_params) do
          {
            reorder: [
              {id: tasks[4].id, target_task_position: tasks[0].position, above_task_position: nil},
              {id: tasks[5].id, target_task_position: tasks[0].position, above_task_position: nil}
            ]
          }
        end

        it 'change the task position to start of the TODO list' do
          post reorder_tasks_path, params: reorder_params

          expect(response).to have_http_status(:ok)
          json_res = JSON.parse(response.body)

          expect(json_res["reordred_tasks"][0]["position"]).to eq(Task.order(:position).first.position.to_s)
          expect(json_res["reordred_tasks"][1]["position"]).to eq(Task.order(:position).second.position.to_s)
        end
      end
    end
  end
end