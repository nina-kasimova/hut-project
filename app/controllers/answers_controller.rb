class AnswersController < ApplicationController
    before_action :set_question, only: [:create]
    before_action :set_answer, only: [:destroy]
  
    def create
      @answer = @question.answers.new(answer_params)
  
      if @answer.save
        redirect_to @question, notice: 'Answer was successfully created.'
      else
        redirect_to @question, alert: 'Error: Answer was not saved.'
      end
    end
  
    private
  
    def set_question
      @question = Question.find(params[:question_id])
    end
  
    def set_answer
      @answer = Answer.find(params[:id])
    end
  
    def answer_params
      params.require(:answer).permit(:body)
    end
  end
  