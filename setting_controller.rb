# Setting Controller
class SettingController < ApplicationController
  # Method for display index page for setting,
  # and perform authorization
  def index
    authorize! :read, GeneralSetting
  end

  # Method for display setting for course batch,
  # and perform authorization
  def course_batch
    authorize! :read, GeneralSetting
  end

  def setting_help
  end

  def database_list
    @con = Mysql2::Client.new(:host => "localhost",:username => "root",:password => "root")
  end

  def empty
    Dir.chdir('db') do
      system 'sh ./empty.sh'
    end
    flash[:notice]="Empty database generated."
    redirect_to home_index_path
  end

  def user
    Dir.chdir('db') do
      system 'sh ./user.sh'
    end
    flash[:notice]="Database with user record generated."
    redirect_to home_index_path
  end

  def full
    Dir.chdir('db') do
      system 'sh ./full.sh'
    end
    flash[:notice]="Database with all module generated."
    redirect_to home_index_path
  end  

  def drop_database
    Dir.chdir('db') do
      system 'sh ./mysql.sh'
    end
    flash[:notice]="Database drop successfully."
    redirect_to home_index_path
  end

  def git_form
  end

  # def git_commit
  #   message=params[:git][:message]
  #   system "git add --all"
  #   system "git commit -m '#{message}'"
  #   system "git pull origin develop"
  #   system "xdotool key ctrl+x"
  #   branch = `git rev-parse --abbrev-ref HEAD`.chomp
  #   system "git push origin '#{branch}'"
  #   flash[:notice]="git Success."
  #   redirect_to setting_index_path
  # end

  def git_status
    Dir.chdir('app/views/setting') do
      system 'git status > _git_status_display.html.erb'
    end
    open("app/views/setting/_git_status_display.html.erb","r+") {|f| f.write("<PRE>") }
    open("app/views/setting/_git_status_display.html.erb","a") {|f| f.write("</PRE> <%= link_to 'Git add', git_add_setting_index_path,class: 'btn btn-success',remote:true%><br/><br/>") }  
  end

  def git_add
      system 'git add --all'
  end

  def git_commit
    message=params[:git][:message]
    system "git commit -m '#{message}'"
    render 'git_commit_form'
  end

  def git_pull
    Dir.chdir('app/views/setting') do
      system 'git pull origin develop > _git_pull_display.html.erb'
    end
    open("app/views/setting/_git_pull_display.html.erb","r+") {|f| f.write("<PRE>") }
    open("app/views/setting/_git_pull_display.html.erb","a") {|f| f.write("</PRE> <%= link_to 'Git push', git_push_setting_index_path,class: 'btn btn-success',remote:true%><br/><br/>") }
  end

  def git_push
    branch = `git rev-parse --abbrev-ref HEAD`.chomp
    Dir.chdir('app/views/setting') do
      system "git push origin '#{branch}'"
    end
  end
end
