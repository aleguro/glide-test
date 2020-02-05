# README

This is the glide test app 

* To run it

$ rails s 

* Command line testing

$ curl "http://localhost:3000/employees?limit=100&offset=2&expand=manager.manager.manager"

* Development Notes

    Additional gems used
    
    - gem 'activeresource' : Simplifies access to api rest resources
    - gem 'vine' : Simplifies hierarchical hash access 