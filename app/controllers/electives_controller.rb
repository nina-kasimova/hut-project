class ElectivesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  authorize_resource


  # GET /electives
  def index
    @electives = Elective.all
  end

  # GET /electives/1
  def show
  end

  # GET /electives/new
  def new
    @elective = Elective.new
  end

  # GET /electives/1/edit
  def edit
  end

  # POST /electives
  def create
    @elective = Elective.new(elective_params)

    if @elective.save
      redirect_to @elective, notice: "Elective was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /electives/1
  def update
    if @elective.update(elective_params)
      redirect_to @elective, notice: "Elective was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /electives/1
  def destroy
    @elective.destroy
    redirect_to electives_url, notice: "Elective was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elective
      @elective = Elective.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elective_params
      params.require(:elective).permit(:Title, :Description, :Speciality, :Location, :Accomodation, :WP_Support, :Type)
    end
end
