class MembershipsController < PrivateController
  before_action :find_set_project
  before_action :project_auth

  def index
    @memberships = @project.memberships
    @membership = @project.memberships.new
    @name = @project.name
  end

  def new
    @membership = @project.membership.new
  end

  def create
    @membership = @project.memberships.new(membership_params)
    if @membership.save
      flash[:notice] = "#{@membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(@project.id)
    else
      render :index
    end
  end

  def update
    @membership = @project.memberships.find(params[:id])
    if @membership.update(membership_params)
      flash[:notice] = "#{@membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(@project.id)
    else
      render :index
    end
  end

  def destroy
    if owner_count(@project) == 1 && @membership.role == 1
      flash[:danger] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@project.id)
    else
      membership = Membership.find(params[:id])
      membership.destroy
      flash[:notice] = "#{membership.user.full_name} was successfully removed"
      redirect_to project_memberships_path(@project.id)
    end
  end

  private

  def project_auth
    if current_user.memberships.find_by(project_id: @project.id) == nil
      flash[:warning] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def find_set_project
    @project = Project.find(params[:project_id])
  end

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

end
