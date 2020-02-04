class EmployeesController < ApplicationController

  # GET /employees.json
  def index

    @employees = Employee.find(:all, params: pagination_params )
    render json: @employees
  end

  # GET /employees/id.json
  def show

    @employee = Employee.find(:all, params: { id: employee_params[:id]} )
    render json: @employee
  end

  private

  # Filter out ony allowed params by query string
  def employee_params

    params.permit(:id, :expands)
  end

  # Set pagination params
  def pagination_params

    p_ret = {}
      p_ret[:limit]  = params.has_key?(:limit)?  params[:limit]  : 1000
      p_ret[:offset] = params.has_key?(:offset)? params[:offset] :    0

    p_ret
  end
end
