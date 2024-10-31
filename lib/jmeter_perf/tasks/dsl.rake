namespace :jmeter_perf do
  desc "Generate JmeterPerf::DSL methods"
  task :dsl_generate, [:dsl_dir, :idl_xml_path] do |t, args|
    require_relative "../helpers/dsl_generator"
    puts "Generating DSL methods..."

    dsl_dir = Pathname(args[:dsl_dir]).expand_path
    idl_xml_path = Pathname(args[:idl_xml_path]).expand_path

    generator = JmeterPerf::Helpers::DSLGenerator.new(
      dsl_dir: dsl_dir,
      idl_xml_path: idl_xml_path
    )

    generator.generate

    puts "Finished generating DSL methods."
  end
end
