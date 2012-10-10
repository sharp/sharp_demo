class GroupsController < GroupController
  set_tab :index, :site_nav
  
  def index
    @user = current_user 
    @post = Post.new
    @post = current_user.stream
  end
  
  def show
    @current_group = Group.find params[:id]
    self.try "set_tab", "group_#{@current_group.id}", :group_nav
  end
  
  def new
    self.try "set_tab", "new_group", :group_nav
    
    @group = Group.new
  end
  
  def update
    @current_group = Group.find params[:id]
    if @current_group.update_attributes params[:group]
      redirect_to @current_group  
    else  
      render :controller => "group/settings", :action => :index
    end
  end

  def create
    @group = current_user.groups.build(params[:group])
    if @group.save
      redirect_to @group  
    else
      render :action => :new
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        self.current_subject = current_user
        redirect_to :home
      end
    end
  end

end
