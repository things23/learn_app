class ChangeTextFormatInCards < ActiveRecord::Migration
  def up
    change_column :cards, :original_text, :string
    change_column :cards, :translated_text, :string
  end

  def down
    change_column :cards, :original_text, :text
    change_column :cards, :translated_text, :text
  end
end
