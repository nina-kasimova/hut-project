class QuestionsController < ApplicationController
  before_action :set_elective, only: [:new, :create, :index]
  def index
    # Find the elective based on the elective_id passed in the URL
    @elective = Elective.find(params[:elective_id])
  
    # Fetch only the questions that belong to the specific elective
    @questions = @elective.questions
  end
  
  
    def show
      @question = Question.find(params[:id])
    end
  
    def new
      @question = @elective.questions.build
    end
  
    def create
      @question = @elective.questions.build(question_params)
  
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
  