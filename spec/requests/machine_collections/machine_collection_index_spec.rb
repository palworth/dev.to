require "rails_helper"

RSpec.describe "Machine Collections", type: :request do
  let(:user) { create(:user) }
  let(:tag1)  { create(:tag) }
  let(:tag2)  { create(:tag) }
  let(:tag3)  { create(:tag) }

  describe "get index page machine_collections/index" do
    it "User can visit thier machine colleciton index" do
      sign_in user
      ruby_col = user.machine_collections.create(title: "Ruby collection")
      ruby_col.tag_list.add(tag1, tag2)
      ruby_col.save
      create(:article, tags: %w[ruby java rails])
      create(:article, tags: %w[ruby javascript rails])
      create(:article, tags: %w[rails preact])
      ruby_col.articles << Article.all
      testing = user.machine_collections.create(title: "Testing")
      testing.tag_list.add(tag3)
      testing.save
      get machinecollections_path
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
    end

    it "can get one of its collections" do
      sign_in user
      ruby_col = user.machine_collections.create!(title: "Ruby collection")
      ruby_col.tag_list.add(tag1)
      ruby_col.save
      create(:article, tags: %w[ruby java rails])
      create(:article, tags: %w[ruby javascript rails])
      create(:article, tags: %w[rails preact])
      ruby_col.articles << Article.all
      get "/machinecollections/#{ruby_col.id}"
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
    end
  end
end
