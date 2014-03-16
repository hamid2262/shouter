class CommentsController < ApplicationController
	skip_authorization_check
	before_filter :load_commentable
  def index
  	@comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.writer = current_user
    if @comment.save
      redirect_to :back
      # redirect_to [@commentable, :comments], notice: "Comment successfully created"
    else
      render :new
    end
  end

  private

  	# def load_commentable
  	# 	resource, id = request.path.split('/')[1,2]
	  # 	@commentable = resource.singularize.classify.conestantize.find(id)
  	# end
  	def load_commentable
  		klass = [PhotoShout, Trip].detect {|c| params["#{c.name.underscore}_id"]}
	  	@commentable = klass.find(params["#{klass.name.underscore}_id"])
  	end  	

    def comment_params
      params.require(:comment).permit(:body)
    end
end
