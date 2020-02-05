class EmployeesController < ApplicationController

  # GET /employees.json
  def index


    employees = Employee.find(:all, params: pagination_params )
    expand    = ExpandedList.new(employees, params.try[:expand], $offices, $departments)

    render json: expand.expand()
  end

  # GET /employees/id.json
  def show

    employee = Employee.find(:all, params: { id: employee_params[:id]} )
    expand   = ExpandedList.new([employee], params.try[:expand], $offices, $departments)

    render json: expand.expand()
  end

  private

  # Filter out ony allowed params by query string
  def employee_params

    params.permit(:id, :expand[])
  end

  # Set pagination params
  def pagination_params

    p_ret = {}
      p_ret[:limit]  = params.has_key?(:limit)?  params[:limit]  : 1000
      p_ret[:offset] = params.has_key?(:offset)? params[:offset] :    0

    p_ret
  end
end
