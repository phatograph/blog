desc "Compile and run the site"
task :default do
  pids = [
    spawn("compass watch _sass"),
    spawn("coffee -b -w -o assets/javascripts -c _coffee/*.coffee"),
    spawn("jekyll serve --watch")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end

desc "Generate jekyll site"
task :generate do
  puts "## Generating Site with Jekyll"

  system("compass compile _sass")
  system("coffee -b -o assets/javascripts -c _coffee/*.coffee")
  system("jekyll build")
end

desc "Default deploy task"
task :deploy do
  Rake::Task[:generate].execute

  deploy_dir = '_site'
  deploy_branch = 'gh-pages'

  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"

    puts "\n## Commiting: Site updated at #{Time.now.utc}"

    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
  end
end
