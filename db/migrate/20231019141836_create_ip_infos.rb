class CreateIpInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :ip_infos do |t|
      t.string  :ip
      t.string  :url
      t.integer :type
      t.string  :continent_name
      t.string  :country_name
      t.string  :region_name
      t.string  :city
      t.string  :zip
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end

    add_index :ip_infos, :ip
    add_index :ip_infos, :url
  end
end
