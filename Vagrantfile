# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "rails-app-berkshelf"

  config.vm.box = "opscode_ubuntu-13.10"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box"

  config.vm.network :private_network, ip: "33.33.33.10"

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      unicorn: {
        site: {
          name: "rails_application"
        }
      },
      rails_app: {
        configuration: {
          files: [
            "aws",
            "carto_db",
            "database",
            "elasticsearch",
            "encryptor",
            "exceptional",
            "google_analytics",
            "kafka",
            "mailer",
            "mongo",
            "redis",
            "zooniverse_home_api"
          ],
          vars: {
            zoo_home_host: "localhost",
            zoo_home_user: "",
            zoo_home_pass: "",
            elasticsearch_host: "localhost",
            elasticsearch_port: 9200,
            kafka_host: "localhost",
            kafka_port: 9092,
            mongo_host: "localhost",
            mongo_port: 27017,
            redis_host: "localhost",
            redis_port: 6279,
            projects: ['galaxy_zoo']
          }
        }
      }
    }

    chef.run_list = [
      "recipe[ruby_build]",
      "recipe[nginx-zoo::default]",
      "recipe[rails_app]",
      "recipe[rails_app::vagrant]",
      "recipe[unicorn]"
    ]
  end
end
