class Projects::RunnersController < Projects::ApplicationController
  before_action :authorize_admin_build!
  before_action :set_runner, only: [:edit, :update, :destroy, :pause, :resume, :show]

  layout 'project_settings'

  def index
    redirect_to namespace_project_settings_ci_cd_path(@project.namespace, @project)
  end

  def edit
  end

  def update
    if @runner.update_attributes(runner_params)
      redirect_to runner_path(@runner), notice: 'Runner 更新成功。'
    else
      render 'edit'
    end
  end

  def destroy
    if @runner.only_for?(project)
      @runner.destroy
    end

    redirect_to runners_path(@project)
  end

  def resume
    if @runner.update_attributes(active: true)
      redirect_to runner_path(@runner), notice: 'Runner 更新成功。'
    else
      redirect_to runner_path(@runner), alert: 'Runner 没有更新。'
    end
  end

  def pause
    if @runner.update_attributes(active: false)
      redirect_to runner_path(@runner), notice: 'Runner 更新成功。'
    else
      redirect_to runner_path(@runner), alert: 'Runner 没有更新。'
    end
  end

  def show
  end

  def toggle_shared_runners
    project.toggle!(:shared_runners_enabled)

    redirect_to namespace_project_settings_ci_cd_path(@project.namespace, @project)
  end

  protected

  def set_runner
    @runner ||= project.runners.find(params[:id])
  end

  def runner_params
    params.require(:runner).permit(Ci::Runner::FORM_EDITABLE)
  end
end
