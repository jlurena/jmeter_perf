namespace :dsl do
  desc "Generate JmeterPerf::DSL methods"
  task :generate do
    require_relative "../jmeter_perf/helpers/dsl_generator"
    # Rake tasks would be ran from root of the project
    lib_dir = Pathname(".").expand_path.join("lib")
    gem_dir = lib_dir.join("jmeter_perf")
    dsl_dir = gem_dir.join("dsl")
    idl_xml_path = lib_dir.join("specifications/idl.xml")

    generator = DSLGenerator.new(
      lib_dir: lib_dir,
      gem_dir: gem_dir,
      dsl_dir: dsl_dir,
      idl_xml_path: idl_xml_path
    )

    generator.generate
  end
end
