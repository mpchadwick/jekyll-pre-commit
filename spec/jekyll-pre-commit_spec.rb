require 'spec_helper'

describe(Jekyll::PreCommit::Runner) do
  let(:runner) { described_class.new }

  context "with no checks" do
    let(:site) { build_site }

    it "returns no messages if no posts are staged" do
      result = runner.run(site, ["spec/fixtures/favicon.ico"])
      expect(result).to match_array([])
    end
  end

  context "with description exists check" do
    let(:site) { build_site({ 'pre-commit' => ['DescriptionExists'] }) }

    it "returns a message if a staged post is missing a description" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-no-description.md"])
      expect(result).to match_array(["No Description was missing a description. "])
    end

    it "doesn't return a message if all staged posts have descriptions" do
      result = runner.run(site, ["spec/fixtures/_posts/2017-01-06-has-description.md"])
      expect(result).to match_array([])
    end
  end
end
