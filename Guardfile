guard "spork" do
  watch("config/application.rb")
  watch("config/environment.rb")
  watch("config/environments/test.rb")
  watch(%r{^config/initializers/.+\.rb$})
  watch("spec/spec_helper.rb") { :rspec }
  watch(%r{^spec/support/.+\.rb$})
  watch("spec/factories.rb")
  watch("config/routes.rb")
end

guard "rspec", cli: "--drb", all_on_start: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch("spec/spec_helper.rb")                        { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb",
                                                             "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
                                                             "spec/feature/#{m[1]}_spec.rb"] }
  watch("app/controllers/application_controller.rb")  { "spec/controllers" }
  watch(%r{^app/models/(.+)\.rb$})                    { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r{^app/views/(.+)/.*\.haml$})                { |m| "spec/features/#{m[1]}_spec.rb" }
#  watch("config/routes.rb")                           { "spec/routing" }
  watch(%r{^app/realtime/(.+)\.rb$})                  { |m| "spec/realtime/#{m[1]}_spec.rb" }
end
