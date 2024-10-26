# TODO List API

A scalable API for managing a tasks in TODO list with advanced reordering capabilities.

## Overview

This TODO List API allows users to manage tasks with CRUD operations and supports drag-and-drop reordering functionality. The API is optimized to handle a large volume of tasks efficiently, using gap-based positioning to ensure smooth reordering even with frequent changes.

## Installation

1. Clone this repository
2. Install Dependencies using `bunlde install` command
3. Setup the Database `rails db:create db:migrate db:seed`
4. Run the Application `rails server`
5. Run Tests `rspec` (Just to heads up I just only wrote unit test for the controller to cover the scenarios unit testing for services was not included)

## Usage

API Endpoints

1. The user should be able to list all tasks in the TODO list by requesting to this endpoint `GET /tasks`
2. The user should be able to add a task to the TODO list by requesting to this endpoint `POST /tasks`
   
**Payload:**
`{task: { "name": "New Task", "description": "Task details" }}`

3. The user should be able to update the details of a task in the TODO list by requesting to this endpoint `PUT /tasks/:id`

**Payload:**
`{ task: { "name": "New Task Updated", "description": "Task details Update" } }`

4. The user should be able to remove a task from the TODO list by requesting to this endpoint `DELETE /tasks/:id`
5. The user should be able to reorder the tasks in the TODO list by requesting to this endpoint `POST /tasks//reorder`

**Scenarios when reordering tasks in TODO list**

1. Task change its position going to start of the TODO list

Required payload:


    To describe in details I think its better to visit the unit testing for this 
    located at: spec/request/tasks_spec.rb start from line 96-155
  
    {
      reorder: [
        {id: tasks_id, target_task_position: first_task_position, above_task_position: nil}
      ]
    }

The Logic uses gap-based positioning to handle task reordering. Initially, tasks position will calculated based on the target tasks position and above tasks position.

<img width="923" alt="Screen Shot 2024-10-26 at 10 59 38 AM" src="https://github.com/user-attachments/assets/47a1963d-adf1-4584-8d75-81446af55889">


