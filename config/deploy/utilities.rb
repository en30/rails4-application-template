def template(file)
   ERB.new(File.read(File.expand_path("../templates/#{file}", __FILE__))).result(binding)
end
