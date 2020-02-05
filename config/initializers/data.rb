
Rails.application.config.after_initialize do

  begin
    department_file = File.read("#{Rails.root}/config/departments.json")
    office_file     = File.read("#{Rails.root}/config/offices.json")

    deparmnts = JSON.parse(department_file)
    offics    = JSON.parse(office_file)

    $departments = Hash[deparmnts.map {|d| [d['id'], d]}]
    $offices     = Hash[offics.map {|o| [o['id'], o]}]

  rescue Errno::ENOENT => e

    $offices     = []
    $departments = []
  end
end