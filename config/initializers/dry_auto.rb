# frozen_string_literal: true

class DryAuto
  extend Dry::Container::Mixin

  namespace :repositories do
    register(:get_winners) { Repositories::GetWinners.new }
  end

  namespace :files do
    register(:set) { Files::Set.new }
  end
end

DI = Dry::AutoInject(DryAuto)

