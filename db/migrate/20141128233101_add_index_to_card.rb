class AddIndexToCard < ActiveRecord::Migration
  def change
    add_index :cards, :user_id
  end
end
