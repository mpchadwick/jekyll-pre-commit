require 'spec_helper'

describe(Jekyll::PreCommit::Runner) do
  let(:runner) { described_class.new }

  context "with no checks" do
    let(:site) { build_site }

    it "bails with no checks enabled message" do
      result = runner.run(site, ["spec/fixtures/favicon.ico"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No pre-commit checks enabled"])
    end

  end

  context "with any check and no posts staged" do
    # Doesn't matter which one
    let(:site) { build_site({ 'pre-commit' => ['DescriptionExists'] }) }

    it "bails with no posts staged message" do
      result = runner.run(site, ["spec/fixtures/favicon.ico"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No posts staged"])
    end
  end

  context "with description exists check" do
    let(:site) { build_site({'pre-commit' => ['DescriptionExists']}) }

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

  context "with description is not duplicate check" do
    let(:site) { build_site({'pre-commit' => ['DescriptionIsNotDuplicate']}) }

    it "fails if a staged post has a duplicate description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-duplicate-description-a.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Duplicate Description A's description was already used. "])
    end

    it "succeeds if a staged post has a unique description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-has-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array([])
    end
  end
end
