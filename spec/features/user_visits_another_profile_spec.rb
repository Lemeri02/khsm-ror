require 'rails_helper'

RSpec.feature 'USER visits another user profile', type: :feature do
  let(:users) do
    2.times.map do
      FactoryGirl.create(:user)
    end
  end

  let!(:games) do
    [
      FactoryGirl.create(:game, id: 97, user: users.last, current_level: 14, prize: 500000, created_at: 20.minutes.ago),
      FactoryGirl.create(:game, id: 98, user: users.last, current_level: 11, prize: 32000, created_at: 30.minutes.ago, finished_at: Time.current, is_failed: true),
      FactoryGirl.create(:game, id: 99, user: users.last, current_level: 6, created_at: 10.minutes.ago, prize: 1000),
    ]
  end

  before(:each) do
    games.first.take_money!

    login_as users.first
  end

  scenario 'successfully visited others profile' do
    visit '/'

    click_link users.last.name

    expect(page).to have_current_path "/users/#{users.last.id}"

    expect(page).to have_content 'Дата'
    expect(page).to have_content 'Вопрос'
    expect(page).to have_content 'Выигрыш'
    expect(page).to have_content 'Подсказки'
    expect(page).not_to have_content 'Сменить имя и пароль'

    expect(page).to have_content users.first.name
    expect(page).to have_content users.last.name

    expect(page).to have_content 'в процессе'
    expect(page).to have_content 'проигрыш'
    expect(page).to have_content 'деньги'
  end
end
