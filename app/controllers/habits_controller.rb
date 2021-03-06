class HabitsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @habit = current_user.last_habit
    @tasks =  @habit ? @habit.tasks_in_ascending_date_order : Array.new()
    respond_to do |format|
      format.html {render "habits/index.html.erb"}
      format.json {render json: @habits }
    end
  end

  def new
  end

  def edit
    @habit = Habit.find(params[:id])
  end

  def show
    @habit = Habit.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @habit }
    end
  end

  def create
    @habit = Habit.new(habit_params)
    if HabitService.create(habit: @habit, actor: current_user)
      redirect_to habits_path
    else
      flash[:alert] = "ERROR: There were one or more problems with your new habit."
      render :new
    end
  end

  def update
    @habit = Habit.find(params[:id])
    if(@habit.update(habit_params))
      flash[:notice] = "Your habit has been updated."
      render json: @habit
    else
      flash[:alert] = "ERROR: Your habit update was unsuccessful."
      render :edit
    end
  end

  def destroy
    @habit = Habit.find(params[:id])
    @habit.destroy
    flash[:notice] = "#{@habit.name} has been deleted."
    redirect_to habits_path
  end

  private
  def habit_params
    params.require(:habit).permit(:user_id,:name,:description,:frequency,:start_date,:end_date,)
  end

end
