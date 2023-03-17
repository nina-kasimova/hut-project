class QuestionsController < ApplicationController
    def index
      @questions = Question.all
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
      @elective = Elective.find(params[:elective_id]) if params[:elective_id]
    end
  
    def question_params
      params.require(:question).permit(:title, :body)
    end
  end
  