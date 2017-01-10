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
    pre_commit_config = {"check" => "FrontMatterVariableExists", "variables" => ["description"]}
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

  context "with FrontMatterVariableExists check only checking description" do
    pre_commit_config = {"check" => "FrontMatterVariableExists", "variables" => ["description"]}
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

  context "with FrontMatterVariableExists check not checking any variables" do
    pre_commit_config = {"check" => "FrontMatterVariableExists"}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "succeeds with no properties to check message" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No variables to check."])
    end
  end

  context "with FrontMatterVariableExists check checking description and image" do
    pre_commit_config = {"check" => "FrontMatterVariableExists", "variables" => ["description", "image"]}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "fails if a staged post has a description, but no image" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-has-description.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Has Description was missing a image. "])
    end

    it "fails if a staged post is missing a description and an image" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(false)
      message = "No Description was missing a description. No Description was missing a image. "
      expect(result[:messages]).to match_array([message])
    end

    it "succeeds if all staged posts have descriptions and images" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-07-has-description-and-image.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array([])
    end
  end

  context "with FrontMatterVariablesIsNotDuplicate checking only description" do
    pre_commit_config = {"check" => "FrontMatterVariableIsNotDuplicate", "variables" => ["description"]}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

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

  context "with FrontMatterVariableIsNotDuplicate not checking any variables" do
    pre_commit_config = {"check" => "FrontMatterVariableIsNotDuplicate"}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "succeeds with no variables to check message" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(true)
      expect(result[:messages]).to match_array(["No variables to check."])
    end
  end

  context "with FrontMatterVariableIsNotDuplicate checking description and image" do
    pre_commit_config = {"check" => "FrontMatterVariableIsNotDuplicate", "variables" => ["description", "image"]}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "fails if a staged post has a unique image, but duplicate description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-09-unique-image-duplicate-description.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Unique Image Duplicate Description's description was already used. "])
    end

    it "fails if a staged post has a duplicate image and duplicate description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-09-duplicate-image-duplicate-description-b.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["Duplicate Image Duplicate Description B's description was already used. Duplicate Image Duplicate Description B's image was already used. "])
    end

    it "succeeds if all staged posts have unique images and unique descriptions" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-09-unique-image-unique-description.md"])
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

  context "with a check that doesn't exist" do
    pre_commit_config = {"check" => "Garbage"}
    let(:site) { build_site({ 'pre-commit' => [pre_commit_config] }) }

    it "fails with non-existent check message" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array(["The check Garbage does not exist! Please fix your configuration."])
    end
  end

  context "with a check that doesn't exist and a check that does" do
    pre_commit_config = [
      {"check" => "FrontMatterVariableExists", "variables" => ["description"]},
      {"check" => "Garbage"}
    ]
    let(:site) { build_site({ 'pre-commit' => pre_commit_config }) }

    it "fails and shows non-existent check message along with other failure messages" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result[:ok]).to eql(false)
      expect(result[:messages]).to match_array([
        "No Description was missing a description. ",
        "The check Garbage does not exist! Please fix your configuration."
      ])
    end
  end
end
