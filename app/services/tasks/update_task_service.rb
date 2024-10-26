module Tasks
  class UpdateTaskService
    attr_reader :params, :task

    def initialize(params:, task:)
      @params = params
      @task = task
    end

    def execute
      task.update(params)
      task
    end
  end
end