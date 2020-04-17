require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    assign(:user, FactoryGirl.create(:user))

    assign(:games, [
      FactoryGirl.build_stubbed(:game, id: 97, created_at: Time.parse('2020.04.25, 00:00'), current_level: 05, prize: 1000),
      FactoryGirl.build_stubbed(:game, id: 98, created_at: Time.parse('2020.04.26, 01:00'), current_level: 10, prize: 32000),
      FactoryGirl.build_stubbed(:game, id: 99, created_at: Time.parse('2020.04.27, 02:00'), current_level: 07, prize: 5000),
    ])

    render
  end

  context 'for anon user' do
    it 'renders player name' do
      expect(rendered).to match /Жора_*/
    end

    it 'renders player balances' do
      expect(rendered).to match '1 000 ₽'
      expect(rendered).to match '32 000 ₽'
      expect(rendered).to match '5 000 ₽'
    end

    it 'anon can not show link for change profile' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end
  end

  context 'for current user' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      assign(:user, user)

      sign_in user

      render
    end

    it 'renders player name' do
      expect(rendered).to match /Жора_*/
    end

    it 'user can show link for change profile' do
      expect(rendered).to match 'Сменить имя и пароль'
    end
  end
end
