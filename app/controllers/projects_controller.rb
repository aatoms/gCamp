class ProjectsController < PrivateController
  before_action :auth
  before_action :set_project, only: [:edit, :show, :update]
  before_action :project_auth, only: [:edit, :show, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      Membership.create!(project_id: @project.id, user_id: current_user.id, role: 1)
      flash[:notice] = "Project was successfully created"
      redirect_to projects_path
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "Project was successfully updated"
      redirect_to project_path
    else
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted"
  end

  private

  def project_auth
    unless Membership.where(project_id: @prject.id).include?(current_user.memberships.find_by(project_id: @project.id))
      flash[:notice] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end

end
