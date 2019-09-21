class NodesController < ApplicationController
  include TreeLinkParser

  before_action :create_vars

  def create_vars
    @found = false
    @visited_ids = []
    @kids = []
  end

  def index
    $redis.set('tree', read_json.to_json)
    @nodes = JSON.parse($redis.get('tree'))

    response_hash = if @nodes['id'] == params[:tree_id].to_i
      {status: 'Found', tree: @nodes}
    else
      {status: 'Failed to find tree'}
    end
    render json: response_hash
  end

  def parents
    parse_tree(JSON.parse($redis.get('tree')), params[:id].to_i)
    status = @found == true ? 'success' : 'Node id not found'
    render json: {status: status, parents: @visited_ids}
  end

  def children
    parse_tree(JSON.parse($redis.get('tree')), params[:id].to_i)
    status = @found == true ? 'success' : 'Node id not found'
    render json: {status: status, kids: @kids}
  end

  private

    def parse_tree(hash, val)
      if hash['id'] == val
        @found = true
        @kids = hash['child'].map {|h1| h1['id']}
        hash
      else
        @visited_ids << hash['id']
        parse_array(hash['child'], hash['id'], val)
      end
    end

    def parse_array(arr, parent, v)
      elements = arr.map {|h1| h1['id']}
      elements.map.with_index do |n, i|
        break if @found == true
        elem_to_del = elements[elements.find_index(n) - 1]
        @visited_ids.delete(elem_to_del)
        node = arr.select{|a| a['id'] == n}.first
        if node['id'] == v || node['child'].present?
          parse_tree(node, v)
        else
          @visited_ids.delete(node['id'])
          @visited_ids.delete(parent) if node['id'] == elements.last
        end
      end
    end

end
