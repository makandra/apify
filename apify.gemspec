# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apify}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Henning Koch"]
  s.date = %q{2010-08-29}
  s.description = %q{Compact definition of JSON APIs for Rails applications. }
  s.email = %q{github@makandra.de}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "apify.gemspec",
     "app/helpers/apify_helper.rb",
     "app/views/apify/api/_actions.html.erb",
     "app/views/apify/api/_client.html.erb",
     "app/views/apify/api/_overview.html.erb",
     "app/views/apify/api/_protocol.html.erb",
     "app/views/apify/api/docs.html.erb",
     "examples/client/client.rb",
     "examples/host/README",
     "examples/host/Rakefile",
     "examples/host/app/controllers/api_controller.rb",
     "examples/host/app/controllers/application_controller.rb",
     "examples/host/app/helpers/api_helper.rb",
     "examples/host/app/helpers/application_helper.rb",
     "examples/host/app/models/api.rb",
     "examples/host/config/boot.rb",
     "examples/host/config/database.yml",
     "examples/host/config/environment.rb",
     "examples/host/config/environments/development.rb",
     "examples/host/config/environments/production.rb",
     "examples/host/config/environments/test.rb",
     "examples/host/config/initializers/backtrace_silencers.rb",
     "examples/host/config/initializers/cookie_verification_secret.rb",
     "examples/host/config/initializers/inflections.rb",
     "examples/host/config/initializers/mime_types.rb",
     "examples/host/config/initializers/new_rails_defaults.rb",
     "examples/host/config/initializers/session_store.rb",
     "examples/host/config/locales/en.yml",
     "examples/host/config/routes.rb",
     "examples/host/db/development.sqlite3",
     "examples/host/db/seeds.rb",
     "examples/host/log/development.log",
     "examples/host/log/production.log",
     "examples/host/log/server.log",
     "examples/host/log/test.log",
     "examples/host/public/404.html",
     "examples/host/public/422.html",
     "examples/host/public/500.html",
     "examples/host/public/favicon.ico",
     "examples/host/public/javascripts/application.js",
     "examples/host/public/robots.txt",
     "examples/host/script/about",
     "examples/host/script/console",
     "examples/host/script/dbconsole",
     "examples/host/script/destroy",
     "examples/host/script/generate",
     "examples/host/script/performance/benchmarker",
     "examples/host/script/performance/profiler",
     "examples/host/script/plugin",
     "examples/host/script/runner",
     "examples/host/script/server",
     "lib/apify.rb",
     "lib/apify/action.rb",
     "lib/apify/api.rb",
     "lib/apify/api_controller.rb",
     "lib/apify/client.rb",
     "lib/apify/errors.rb",
     "lib/apify/exchange.rb",
     "lib/apify/schema_helper.rb",
     "spec/apify/action_spec.rb",
     "spec/apify/client_spec.rb",
     "spec/app_root/app/controllers/api_controller.rb",
     "spec/app_root/app/controllers/application_controller.rb",
     "spec/app_root/app/models/api.rb",
     "spec/app_root/config/boot.rb",
     "spec/app_root/config/database.yml",
     "spec/app_root/config/environment.rb",
     "spec/app_root/config/environments/in_memory.rb",
     "spec/app_root/config/environments/mysql.rb",
     "spec/app_root/config/environments/postgresql.rb",
     "spec/app_root/config/environments/sqlite.rb",
     "spec/app_root/config/environments/sqlite3.rb",
     "spec/app_root/config/routes.rb",
     "spec/app_root/lib/console_with_fixtures.rb",
     "spec/app_root/script/console",
     "spec/controllers/api_controller_spec.rb",
     "spec/models/api_spec.rb",
     "spec/rcov.opts",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/makandra/apify}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Compact definition of JSON APIs for Rails applications.}
  s.test_files = [
    "spec/apify/action_spec.rb",
     "spec/apify/client_spec.rb",
     "spec/spec_helper.rb",
     "spec/app_root/app/controllers/api_controller.rb",
     "spec/app_root/app/controllers/application_controller.rb",
     "spec/app_root/app/models/api.rb",
     "spec/app_root/lib/console_with_fixtures.rb",
     "spec/app_root/config/environments/in_memory.rb",
     "spec/app_root/config/environments/mysql.rb",
     "spec/app_root/config/environments/postgresql.rb",
     "spec/app_root/config/environments/sqlite.rb",
     "spec/app_root/config/environments/sqlite3.rb",
     "spec/app_root/config/boot.rb",
     "spec/app_root/config/environment.rb",
     "spec/app_root/config/routes.rb",
     "spec/controllers/api_controller_spec.rb",
     "spec/models/api_spec.rb",
     "examples/client/client.rb",
     "examples/host/app/controllers/application_controller.rb",
     "examples/host/app/controllers/api_controller.rb",
     "examples/host/app/helpers/application_helper.rb",
     "examples/host/app/helpers/api_helper.rb",
     "examples/host/app/models/api.rb",
     "examples/host/config/environments/production.rb",
     "examples/host/config/environments/development.rb",
     "examples/host/config/environments/test.rb",
     "examples/host/config/initializers/backtrace_silencers.rb",
     "examples/host/config/initializers/inflections.rb",
     "examples/host/config/initializers/mime_types.rb",
     "examples/host/config/initializers/new_rails_defaults.rb",
     "examples/host/config/initializers/session_store.rb",
     "examples/host/config/initializers/cookie_verification_secret.rb",
     "examples/host/config/routes.rb",
     "examples/host/config/environment.rb",
     "examples/host/config/boot.rb",
     "examples/host/db/seeds.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<jsonschema>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<jsonschema>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<jsonschema>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
  end
end

