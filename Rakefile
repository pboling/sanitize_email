# frozen_string_literal: true

require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  desc("alias test task to spec")
  task(test: :spec)
rescue LoadError
  task(:spec) do
    warn("rspec is disabled")
  end
end

begin
  require "reek/rake/task"
  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = "lib/**/*.rb"
  end
rescue LoadError
  task(:reek) do
    warn("reek is disabled")
  end
end

begin
  require "yard-junk/rake"

  YardJunk::Rake.define_task
rescue LoadError
  task("yard:junk") do
    warn("yard:junk is disabled")
  end
end

begin
  require "yard"

  YARD::Rake::YardocTask.new(:yard)
rescue LoadError
  task(:yard) do
    warn("yard is disabled")
  end
end

begin
  require "rubocop/lts"
  Rubocop::Lts.install_tasks
rescue LoadError
  task(:rubocop_gradual) do
    warn("RuboCop (Gradual) is disabled")
  end
end

task default: %i[spec rubocop_gradual yard yard:junk]
