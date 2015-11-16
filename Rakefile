desc "Compile and run the site"
task :default do
  pids = [
    spawn("compass watch _sass"),
    spawn("jekyll serve --watch --baseurl ''")
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
  system("jekyll build")
end

desc "Default deploy task"
task :deploy do
  deploy_dir = '_site'
  deploy_branch = 'gh-pages'

  rm_rf deploy_dir
  Rake::Task[:generate].execute

  cd "#{deploy_dir}" do
    system "git init"
    system "git add ."
    system "git add -u"
    system "git remote add origin git@github.com:phatograph/blog.git"

    puts "\n## Commiting: Site updated at #{Time.now.utc}"

    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin master:#{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
  end
end
