class CreateTweets < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :token
      t.string :secret

  		t.timestamps null: false
  	end

    create_table :tweets do |t|
    	t.belongs_to :user, index: true
      t.string :username
      t.string :tweet, limit: 140

      t.timestamps null: false
    end
  end
end
