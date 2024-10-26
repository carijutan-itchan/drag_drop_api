class TasksController < ApplicationController

  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.order(:position).limit(1000)

    render json: @tasks
  end

  def create
    task_service = Tasks::CreateTaskService.new(params: task_params)
    @task = task_service.execute

    if @task.errors.empty?
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    task_service = Tasks::UpdateTaskService.new(params: task_params, task: @task)
    @task = task_service.execute

    if @task.errors.empty?
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Unable to delete task.' }, status: :unprocessable_entity
    end
  end

  def reorder
    tasks_service = Tasks::ReorderTaskService.new(params: reorder_params)
    @reordered_tasks = tasks_service.execute
    
    render json: { reordred_tasks: @reordered_tasks }, status: :ok
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def reorder_params
    params.require(:reorder).map do |task|
      task.permit(:id, :target_task_position, :above_task_position)
    end
  end
end