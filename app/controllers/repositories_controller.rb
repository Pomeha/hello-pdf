# frozen_string_literal: true

class RepositoriesController < ApplicationController
  include DI[
    get_winners: 'repositories.get_winners',
    set_files_to: 'files.set'
  ]

  def new
    @repository = Repository.new
  end

  def create
    begin
      repository = get_winners.(permitted_params[:url])
    rescue RestClient::NotFound
      flash[:error] = 'Repository not found'
      redirect_to new_repository_path(flash: 'Repository not found')
    end

    redirect_to repository_path(id: repository) if repository
  end

  def show
    repository = Repository.find(params[:id])
    @winners = repository.winners
    @pdfs, @archive = set_files_to.(repository.winners)
  end

  private

  def permitted_params
    params.require(:repository).permit(:url)
  end
end
