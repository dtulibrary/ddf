class AddExhibitOverview < ActiveRecord::Migration
  def change
    create_table :exhibit_overviews do |t|
      t.string :institution
      t.string :research_area
      t.string :contact_details
      t.references :exhibit, index: true
    end
    add_foreign_key :exhibit_overviews, :spotlight_exhibits, column: :exhibit_id
  end
end
