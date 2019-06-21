class ExportMoviesJob < ApplicationJob
  queue_as :default

  def perform(current_user)
    MovieExporter.new.call(current_user, "tmp/movies.csv")
  end
end
