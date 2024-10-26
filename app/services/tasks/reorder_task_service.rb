module Tasks
  class ReorderTaskService

    attr_reader :params
    attr_accessor :errors

    def initialize(params:)
      @params = params
    end

    # Sample payload
    # {
    #   "reorder": [
    #     {"id": 1, "target_task_position": 3, "above_task_position": nil}
    #     {"id": 4, "target_task_position": 3, "above_task_position": nil}
    #     {"id": 5, "target_task_position": 3, "above_task_position": nil}
    #   ]
    # }

    def execute
      tasks_to_update = Task.where(id: params.pluck(:id)).order(:position)
      tasks_to_update.each_with_index do |task, index|
        target_task_position = params[index][:target_task_position].to_f
        above_task_position = params[index][:above_task_position].to_f

        new_position = calculate_new_task_position(tasks_to_update, index, target_task_position, above_task_position)

        task.update_column(:position, new_position)
      end

      tasks_to_update
    end

    private

    def calculate_new_task_position(tasks_to_update, index, target_task_position, above_task_position)
      # blank above_task_position means the tasks moves at the beginning
      # The nearest selected task is the first element in array (tasks_to_update)
      if above_task_position.blank?
        if index.zero?
          target_task_position - 0.5
        else
          above_task_position = tasks_to_update[index - 1].position
          (above_task_position + target_task_position) / 2
        end
      else
        if index.zero?
          (above_task_position + target_task_position) / 2
        else
          above_task_position = tasks_to_update[index - 1].position
          (above_task_position + target_task_position) / 2
        end
      end
    end
  end
end