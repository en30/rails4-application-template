# overriding Thor::Actions#source_paths
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def after_bundle_install(&callback)
  @callbacks ||= []
  @callbacks << callback
end

def bundle_install
  run 'bundle install'
  @callbacks.each {|c| c.call }
end

@app_name = File.basename(destination_root)

bundle_install
