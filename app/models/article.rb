class Article < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  mapping do
    # indexes :_id, index: :not_analyzed
    indexes :title, analyzer: 'snowball', boost: 100, type: 'string'
    indexes :content, type: 'text'
    indexes :published_on, type: 'date'
  end


def self.search(params)
  # binding.pry
  tire.search(load: true,page: params[:page], per_page: 2) do
    query { string params[:query], fields: [:title, :content], default_operator: "AND"} if params[:query].present?
   # query { string params[:query], fields: [:title, :content, :published_on] } if params[:query].present?
  end
end

end
