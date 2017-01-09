require 'spec_helper'

describe(Jekyll::PreCommit::Runner) do
  let(:runner) { described_class.new }

  context "with no checks" do
    let(:site) { build_site }

    it "succeeds with no checks enabled message" do
      result = runner.run(site, ["spec/fixtures/favicon.ico"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No pre-commit checks enabled"])
    end

  end

  context "with any check" do
    # Doesn't matter which one
    pre_commit_config = {"check" => "FrontMatterPropertyExists", "properties" => ["description"]}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "succeeds with no posts staged message when no posts are staged" do
      result = runner.run(site, ["spec/fixtures/favicon.ico"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No posts staged"])
    end

    # Drafts are still works in progress, so we don't check them
    it "succeeds if a draft fails a check" do
      result = runner.run(site, ["spec/fixtures/_drafts/2017-01-07-draft-with-no-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No posts staged"])
    end
  end

  context "with FrontMatterPropertyExists check only checking that description exists" do
    pre_commit_config = {"check" => "FrontMatterPropertyExists", "properties" => ["description"]}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "fails if a staged post is missing a description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["No Description was missing a description. "])
    end

    it "succeeds if all staged posts have descriptions" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-has-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array([])
    end
  end

  context "with FrontMatterPropertyExistsCheck not checking any properties" do
    pre_commit_config = {"check" => "FrontMatterPropertyExists"}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "succeeds with no properties to check message" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No properties to check."])
    end
  end

  context "with description is not duplicate check" do
    let(:site) { build_site({'pre-commit' => [{"check" => "DescriptionIsNotDuplicate"}]}) }

    it "fails if a staged post has a duplicate description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-duplicate-description-a.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Duplicate Description A's description was already used. "])
    end

    it "succeeds if all staged posts have a unique description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-has-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array([])
    end
  end

  context "with description is good length check" do
    let(:site) { build_site({'pre-commit' => [{"check" => "DescriptionIsGoodLength"}]}) }

    it "fails if a staged post has a description that's too long" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-description-is-too-long.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Long Ass Description's description is too long. "])
    end

    it "fails if a staged post has a description that's too short" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-description-is-too-short.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Short Description's description is too short. "])
    end

    it "passes if all staged posts have descriptions that are a good length " do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-description-is-good-length.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array([])
    end
  end
end
