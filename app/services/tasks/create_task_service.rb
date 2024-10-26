module Tasks
  class CreateTaskService
    attr_reader :params

    def initialize(params:)
      @params = params
    end

    def execute
      task = Task.new
      task.name = params[:name]
      task.description = params[:description]
      task.position = set_position
      task.save
      task
    end

    private

    def set_position
      last_task = Task.order(:position).last
      (last_task&.position || 2999) + 1
    end
  end
end