require 'spec_helper'

describe(Jekyll::PreCommit::Runner) do
  let(:config) do
    Jekyll.configuration({
        "source" => source_dir
      })
  end
  let(:site) { Jekyll::Site.new(config) }
  let(:runner) { Jekyll::PreCommit::Runner.new }
  before(:each) do
    site.reset
    site.read
  end
  it "returns no messages if no posts are staged" do
    result = runner.run(site, ["spec/fixtures/favicon.ico"])
    expect(result).to match_array([])
  end
end
