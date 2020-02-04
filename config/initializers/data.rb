
Rails.application.config.after_initialize do

  begin
    department_file = File.read("#{Rails.root}/config/departments.json")
    office_file     = File.read("#{Rails.root}/config/offices.json")

    $departments    = JSON.parse(department_file)
    $offices        = JSON.parse(office_file)

  rescue Errno::ENOENT => e

    $offices = []
    $departments = []
  end
end