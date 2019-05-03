# frozen_string_literal: true

require 'rest-client'

class Repositories::GetWinners
  def call(url)
    repository = set_repository(url)
    get_winners_for(repository)

    repository
  end

  private

  def set_repository(url)
    author, project = url.split('github.com').last.split('/').last(2) # facepalm

    Repository.find_or_create_by(url: url, author: author, project: project) if (author && project)
  end

  def get_winners_for(repository)
    response = RestClient.get("https://api.github.com/repos/#{repository.author}/#{repository.project}/stats/contributors").body

    winners = JSON.parse(response).last(3).pluck('author').pluck('login').reverse # pacani, kak mog, api github'a eto bol'
    repository.update(winners: winners) if winners
  end
end
