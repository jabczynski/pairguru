class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    "#{Movies::Fetcher::API_URL}#{poster}"
  end
end
