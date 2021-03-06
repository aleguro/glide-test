=begin

# Test from console

employees = Employee.find(:all,params: { limit: 5 }).map(&:attributes)
result    = ExpandableList.new(employees, Array({:expand=>["manager.department"]}.try(:[],:expand)), $offices, $departments).expand()
result    = ExpandableList.new(employees, Array({:expand=>["manager.manager"]}.try(:[],:expand)), $offices, $departments).expand()
result    = ExpandableList.new(employees, Array({:expand=>["manager.manager.manager"]}.try(:[],:expand)), $offices, $departments).expand()

=end

# Given a list of rows, expands the attributes with bodies of
#   information based on different sources such as the api source and
#   offices and departments static dictionaries.
class ExpandableList

  def initialize(rows, levels, offices, departments)

    @rows        = rows
    @levels      = levels
    @offices     = offices
    @departments = departments
    @managers    = []
  end

  # Expand a row by filling in the attributes with full entities from different sources
  # => Input {id: 1, name: 'alejandro', last_name:'gurovich', office:1}
  # Output => {id: 1, name: 'alejandro', last_name:'gurovich', office: { id:, name: 'sales'}}
  def expand()

    normalize_levels()

    @levels.each do |level|

      deepest  = level.split('.').last
      managers = []
      @rows.each do |row|

        val = row.access(level)

        if deepest == 'manager'

          managers << row if val.present?
        elsif deepest == 'department' && val.present?

          row.set(level, @departments[val])
        elsif deepest == 'superdepartment' && val.present?

          row.set(level, @departments[val])
        elsif deepest == 'office' && val.present?

          row.set(level, @departments[val])
        end
      end

      if deepest == 'manager' and !managers.empty?

        ids       = {id: managers.map(&(Proc.new {|x| x.access(level)})) }
        employees = Employee.find(:all, :from => "/bigcorp/employees?#{ids.to_query}").map(&:attributes)

        managers.each do |manager|

          employee = employees.select { |employee| employee[:id] == manager.access(level) }.first()
          manager.set(level, employee)
        end
      end
    end

    @rows
  end

  private

  # Deconstruct a list of expand requests to an array of combinations with hierarchies
  # => Input ['manager.offices','offices.departments']
  # Outut => ['manager','offices','manager.offices', 'offices.departments']
  def normalize_levels()

    max  = 0
    @levels.each do |level|

      elems = level.split('.').count
      max   = elems if elems > max
    end

    r = []
    max.times.each do |time|
      @levels.each do |l|

        r << l.split('.').slice(0..time).join('.')
      end
    end

    @levels = r.uniq
  end
end