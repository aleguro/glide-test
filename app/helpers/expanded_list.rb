# Given a list of jsons, expands the attributes with whole bodys of
#   information based on different sources such as the list itself,
#   offices and departments dictionaries
class ExpandedList

  def initialize(rows, levels, offices, departments)

    @rows        = rows
    @levels      = levels.split('.')
    @offices     = offices
    @departments = departments
  end

  # Expands a json row by row by adding 1-to many records
  # depending on the expand_to configuration
  def expand()

    return @rows if @levels.nil?
    rows = []

    @rows.each do |row|

      puts "row: #{row.attributes}"
      rows << expand_row(row.attributes, @rows, @levels )
    end

    rows
  end

  def expand_row(row, list, levels=[])

    level = levels.slice(0)

    if !level.nil?

      puts "level: #{level}"
      puts "row: #{row}"
      puts "r.level: #{row[level]}"
      part       = ExpandBase.build(row, level , list).expand()
      puts "part: #{part}"

      row[level] = part
      expand_row(row[level], levels)
    end

    row
  end
end

# Expands a rows by exploding an Id attribute with its full body
class ExpandBase

  def initialize(hash, key, dictionary)

    @hash       = hash
    @key        = key
    @dictionary = dictionary
  end

  # Do nothing must be inherited
  def expand()

    return @key
  end

  # TODO: perhaps we can have a factory pattern outside the base class but...
  def self.build(hash, key, dictionary)

      case key

          when 'department'
          return DepartmentExpand.new(hash, key, $departments)

        when 'superdepartment'
          return SuperDepartmentExpand.new(hash, key, $departments)

        when 'office'
          return OfficeExpand.new(hash, key, $offices)

        when 'manager'
          return ManagerExpand.new(hash, key, dictionary)

        else
          return new(hash, key, [])
      end
    end
end

class SuperDepartmentExpand < ExpandBase

  def initialize(hash, key, dictionary)
    super hash, key, dictionary
  end

  def expand()

    return @dictionary[@hash[:superdepartment]]
  end
end

# Expands a row attribute by the :department ID
class DepartmentExpand < ExpandBase

  def initialize(hash, key, dictionary)

    super hash, key, dictionary
  end

  def expand()

    return @dictionary[@hash[:department]]
  end
end

# Expands a row attribute by the :office ID
class OfficeExpand < ExpandBase

  def initialize(hash, key, dictionary)

    super hash, key, dictionary
  end

  def expand()

    return @dictionary[@hash[:office]]
  end
end

# Expands a row attribute by the :manager ID
class ManagerExpand < ExpandBase

  def initialize(hash, key, dictionary)

    super hash, key, dictionary
  end

  # TODO: This can be improved by caching he Ids of the found employees on the fly
  def expand()

    return @dictionary.select {

        |row| row[:id] == @hash[:manager]}.try(:first)
  end
end