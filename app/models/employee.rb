class Employee < ActiveResource::Base
  self.site = "https://rfy56yfcwk.execute-api.us-west-1.amazonaws.com/bigcorp/"
  self.element_name = 'employees'
  self.include_format_in_path = false
end