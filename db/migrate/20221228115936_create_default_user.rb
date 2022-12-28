class CreateDefaultUser < ActiveRecord::Migration[7.0]
  def up
    User.create(email: 'admin@email.com', password: 'ilovenimble')
  end

  def down
    User.destroy_by(email: 'admin@email.com')
  end
end
