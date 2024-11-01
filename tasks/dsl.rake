namespace :dsl do
  desc "Generate JmeterPerf::DSL methods"
  task :generate do
    require_relative "../lib/jmeter_perf/helpers/dsl_generator"
    puts "Generating DSL methods..."
    # Rake tasks would be ran from root of the project
    lib_dir = Pathname(".").expand_path.join("lib")
    gem_dir = lib_dir.join("jmeter_perf")
    dsl_dir = gem_dir.join("dsl")
    idl_xml_path = lib_dir.join("specifications/idl.xml")

    generator = JmeterPerf::Helpers::DSLGenerator.new(
      dsl_dir: dsl_dir,
      idl_xml_path: idl_xml_path,
      document_dsl: false
    )

    generator.generate

    puts "Finished generating DSL methods."
  end
end
