desc "compile and run the site"
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
