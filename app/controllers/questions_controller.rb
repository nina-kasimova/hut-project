class QuestionsController < ApplicationController
  before_action :set_elective, only: [:new, :create, :index]
  def index
    @elective = Elective.find(params[:elective_id])
    @questions = @elective.questions.where(approved: true)
  end  
  
  
    def show
      @question = Question.find(params[:id])
    end

    def approve
      @question.update(approved: true)
      redirect_to admin_dashboard_index_path, notice: 'Question approved.'
    end    
  
    def new
      @question = @elective.questions.build
    end
  
    def create
      @question = @elective.questions.build(question_params)
      @question.approved = false
    
      if @question.save
        redirect_to @question, notice: 'Question was successfully created.'
      else
        render :new
      end
    end    
  
    private
  
    def set_elective
      @elective = Elective.find(params[:elective_id])
    end     
  
    def question_params
      params.require(:question).permit(:title, :body, :elective_id)
    end    
  end
  