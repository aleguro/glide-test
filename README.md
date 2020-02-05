# README

This is the glide test app 

* Prerequisite

  * Ruby version 2.6.1
    
    ### Check your Ruby version
    
    ```shell
    ruby -v
    ```
    If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):
    
    ```shell
    rbenv install 2.5.1
    ```
  
  * Install Bundler to manager dependencies: 
      ```shell
      gem install bundler
      ```
    
* Install and run it !

```shell
$ bundle install
$ rails s
```
Run with `--help` or `-h` for options.

* Finally, go to `http://localhost:3000/employees?limit=10` , and you'll see some json !

* Command line testing

$ curl "http://localhost:3000/employees?limit=100&offset=2&expand=manager.manager.manager"

* Development Notes

    Additional gems used
    
    - gem 'activeresource' : Simplifies access to api rest resources
    - gem 'vine' : Simplifies hierarchical hash access 