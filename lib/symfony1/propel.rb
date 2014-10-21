namespace :symfony do
  namespace :propel do
    desc "Ensure Propel is correctly configured"
    task :setup, :roles => :app, :except => { :no_release => true } do
      conf_files_exists = capture("if test -s #{shared_path}/config/propel.ini -a -s #{shared_path}/#{databases_config_path} ; then echo 'exists' ; fi").strip

      # share childs again (for propel.ini file)
      shared_files << "config/propel.ini"
      deploy.share_childs

      if (!conf_files_exists.eql?("exists"))
        run "#{try_sudo} cp #{symfony_lib}/plugins/sfPropelPlugin/config/skeleton/config/propel.ini #{shared_path}/config/propel.ini"
        symfony.configure.database
      end
    end

    desc "Migrates database to current version"
    task :migrate, :roles => :app, :except => { :no_release => true } do
      puts "propel doesn't have built-in migration for now"
    end

    desc "Generate model lib form and filters classes based on your schema"
    task :build_classes, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} #{php_bin} #{latest_release}/symfony propel:build --model --env=#{symfony_env_prod}"
      run "#{try_sudo} #{php_bin} #{latest_release}/symfony propel:build --forms --env=#{symfony_env_prod}"
      run "#{try_sudo} #{php_bin} #{latest_release}/symfony propel:build --filters --env=#{symfony_env_prod}"
    end

    desc "Generate code & database based on your schema"
    task :build_all, :roles => :app, :except => { :no_release => true } do
      if Capistrano::CLI.ui.agree("Do you really want to rebuild #{symfony_env_prod}'s database? (y/N)")
        run "#{try_sudo} sh -c 'cd #{latest_release} && #{php_bin} ./symfony propel:build --sql --db --no-confirmation --env=#{symfony_env_prod}'"
      end
    end

    desc "Generate code & database based on your schema & load fixtures"
    task :build_all_and_load, :roles => :app, :except => { :no_release => true } do
      if Capistrano::CLI.ui.agree("Do you really want to rebuild #{symfony_env_prod}'s database and load #{symfony_env_prod}'s fixtures? (y/N)")
        run "#{try_sudo} sh -c 'cd #{latest_release} && #{php_bin} ./symfony propel:build --sql --db --and-load --no-confirmation --env=#{symfony_env_prod}'"
      end
    end

    desc "Generate sql & database based on your schema"
    task :build_db, :roles => :app, :except => { :no_release => true } do
      if Capistrano::CLI.ui.agree("Do you really want to rebuild #{symfony_env_prod}'s database? (y/N)")
        run "#{try_sudo} sh -c 'cd #{latest_release} && #{php_bin} ./symfony propel:build --sql --db --no-confirmation --env=#{symfony_env_prod}'"
      end
    end

    desc "Generate sql & database based on your schema & load fixtures"
    task :build_db_and_load, :roles => :app, :except => { :no_release => true } do
      if Capistrano::CLI.ui.agree("Do you really want to rebuild #{symfony_env_prod}'s database and load #{symfony_env_prod}'s fixtures? (y/N)")
        run "#{try_sudo} sh -c 'cd #{latest_release} && #{php_bin} ./symfony propel:build --sql --db --and-load --no-confirmation --env=#{symfony_env_prod}'"
      end
    end
  end
end
