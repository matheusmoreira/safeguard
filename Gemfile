source :rubygems

gemspec

{ acclaim: '~/projects/acclaim', rookie: '~/projects/rookie' }.each do |project, path|
  path = File.expand_path path
  gem project.to_s, path: path if Dir.exists? path
end
