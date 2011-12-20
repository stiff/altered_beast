namespace :app do
  task :bootstrap => :setup do
    Debugger.start if Kernel.const_defined?(:Debugger)
    say "Bootstrapping #{@app_name}..."
    
    puts
    say "1) Create database.yml config file."
    say "2) Load Database Schema."
    say "3) Setup the Application Database."
    puts

    %w(database_config database_schema app_specific finished).each do |task|
      Rake::Task["app:#{task}"].invoke
    end
  end

  task :database_config do
    db_config = "config/database.yml"
    db_config = File.readlink(db_config) if File.symlink?(db_config)
    if File.exist?(db_config)
      say "It looks like you already have a database.yml file."
      @restart = agree("Would you like to CLEAR it and start over? [y/n]")
    end

    unless !@restart && File.exist?(db_config)
      if @restart || agree("Would you like to create a database.yml file? [y/n]")
        options = OpenStruct.new :host => 'localhost', :username => 'root', :adapter => 'mysql2',
          :keys => [:adapter, :host, :database, :username, :password, :socket], :pattern => /_(dev.*|prod.*|test)$/
        class << options
          def get_binding() binding end
          def test_database
            @test_database ||= database.gsub(pattern, '') + '_test'
          end
        end

        puts
        options.host     = ask("Host name:") { |q| q.default = options.host }
        puts
        say "This same database will be used for your DEV and PRODUCTION environments."
        say "The test database name will be inferred from this database name."
        options.database = ask("Database name:")
        puts
        options.username = ask("User name:") { |q| q.default = options.username }
        puts
        options.password = ask("Password:") { |q| q.echo = "*" }
        puts
        options.socket   = ask("Socket path: (blank by default)")
        [:host, :socket].each do |attr|
          if options.send(attr).to_s.size == 0
            options.delete_field(attr)
            options.keys.delete(attr)
          end
        end
        require 'erb'
        erb = ERB.new(IO.read('config/app_bootstrap-database-template.erb'), nil, '<>')
        File.open File.expand_path(db_config), 'w' do |f|
          f.write erb.result(options.get_binding)
        end
        say "Your databases:"
        say "Development: '#{options.database}'"
        say "Production:  '#{options.database}'"
        say "Test:        '#{options.test_database}'"
      else
        cp 'config/database.sample.yml', db_config
        say "I have copied database.sample.yml over.  Now, edit #{db_config} with your correct database settings, and re-run app:bootstrap."
        return
      end
    end

    puts
  end

  task :database_schema do
    unless agree("Now it's time to load the schema into the development and test databases.  Any existing data will be OVERWRITTEN. Are you sure you wish to continue? [y/n]")
      raise "Cancelled"
    end
    puts

    mkdir_p Rails.root.join('log')

    Rake::Task['environment'].invoke
    begin
      say "Attempting to reset the database."
      Rake::Task['db:reset'].invoke
    rescue
      say "rake db:reset failed, you should look into that."
      puts $!.inspect
      say "If this doesn't work, create your database manually and re-run this app:bootstrap task."
      say "At any rate, I'm going to attempt to load the schema."
      Rake::Task['db:schema:load'].invoke
    end
    Rake::Task["tmp:create"].invoke
    puts
  end

  # Override this in a rakefile for your app to seed the database, flip switches, twiddle knobs, etc.
  task :app_specific do
  end

  task :finished do
    say '=' * 80
    puts
    say "#{@app_name} is ready to roll."
    say "Okay, thanks for bootstrapping!  I know I felt some chemistry here, did you?"
    say "Now, start the application with 'rails server' and get to work!"
    Rake::Task["db:test:clone"].invoke
  end

  task :setup do
    require 'ostruct'
    require 'highline'
    require 'forwardable'
    @terminal = HighLine.new
    @app_name = File.basename(Rails.root).capitalize
    @restart  = false
    class << self
      extend Forwardable
      def_delegators :@terminal, :agree, :ask, :choose, :say
    end
  end
end