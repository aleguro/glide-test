class EmployeesController < ApplicationController

  before_action :modify_params, only: [:index, :show]

  # GET /employees.json
  def index

    puts "params: #{Array(params.try(:[],:expand))}"

    employees = Employee.find(:all, params: pagination_params ).map(&:attributes)
    expand    = ExpandableList.new(employees, Array(params.try(:[],:expand)), $offices, $departments)

    render json: expand.expand()
  end

  # GET /employees/id.json
  def show

    employee = Employee.find(:all, params: { id: employee_params[:id]} ).map(&:attributes)
    expand   = ExpandableList.new([employee],
                                  params.try(:[],:expand),
                                  $offices,
                                  $departments)

    render json: expand.expand()
  end

  private

  def modify_params
    
    params[:expand] = params[:expand].split(',') if params.has_key?(:expand)

    puts "modified params: #{params[:expand]}"
  end

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
