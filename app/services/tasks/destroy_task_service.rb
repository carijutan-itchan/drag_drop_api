module Tasks
  class DestroyTaskService

    attr_reader :task

    def initialize(task:)
      @task = task
    end

    def execute
      task.destroy
    end
  end
end