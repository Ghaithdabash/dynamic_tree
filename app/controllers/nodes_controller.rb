class NodesController < ApplicationController
  include TreeLinkParser

  def index
    byebug
    @nodes = read_json

    render json: @nodes
  end

  def show
    render json: @node
  end

  private
    def find_node
      @node = Node.find(params[:id])
    end

    def node_params
      params.require(:node).permit(:parent_id)
    end
end
