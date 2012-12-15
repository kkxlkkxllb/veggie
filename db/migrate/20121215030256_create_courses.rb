class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :ctags
      t.string :language

      t.timestamps
    end
    add_index(:u_words,[:member_id,:word_id],:unique => true)
  end
end
