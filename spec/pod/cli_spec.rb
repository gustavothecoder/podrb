# frozen_string_literal: true

require_relative "../support/test_helpers"

RSpec.describe Pod::CLI do
  describe "input interpretation" do
    context "when the input is invalid" do
      it "tells the user that the command was not found" do
        result = TestHelpers::CLI.run_cmd("pod invalid")

        expect(result).to eq('Could not find command "invalid".')
      end
    end
  end

  describe "version command" do
    it "returns the pod version" do
      original_result = TestHelpers::CLI.run_cmd("pod version")
      alias_result1 = TestHelpers::CLI.run_cmd("pod -V")
      alias_result2 = TestHelpers::CLI.run_cmd("pod --version")

      expect(original_result).to eq(Pod::VERSION)
      expect(alias_result1).to eq(original_result)
      expect(alias_result2).to eq(original_result)
    end
  end

  describe "init command" do
    it "creates the initial config files" do
      expected_output = <<~OUTPUT
        Creating config files...
        Pod successfully initialized!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("pod init")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "add command", :init_pod do
    it "adds a podcast to the pod database" do
      podcast_feed = "spec/fixtures/soft_skills_engineering.xml"
      expected_output = <<~OUTPUT
        Adding the podcast...
        Podcast successfully added to the database!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("pod add #{podcast_feed}")

      expect(result).to eq(expected_output.chomp)
    end

    context "when the --sync-url option is used" do
      it "adds a podcast to the pod database" do
        podcast_feed = "spec/fixtures/fabio_akita.xml"
        sync_url = "https://www.fabio.com/feed.xml"
        expected_output = <<~OUTPUT
          Adding the podcast...
          Podcast successfully added to the database!
        OUTPUT

        result = TestHelpers::CLI.run_cmd("pod add #{podcast_feed} --sync-url=#{sync_url}")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end

  describe "podcasts command", :init_pod, :populate_db do
    it "returns the podcast records" do
      expected_output = <<~OUTPUT
        +----+------------------+------------------+-----------------+-----------------+
        | id |       name       |    description   |       feed      |     website     |
        +----+------------------+------------------+-----------------+-----------------+
        |  1 | Soft Skills Engi | It takes more th | https://softski | https://softski |
        |    | neering          | an great code to | lls.audio/feed. | lls.audio/      |
        |    |                  |  be a great engi | xml             |                 |
        |    |                  | neer. Soft Skill |                 |                 |
        |    |                  | s Engineering is |                 |                 |
        |    |                  |  a weekly advice |                 |                 |
        |    |                  |  podcast for sof |                 |                 |
        |    |                  | tware developers |                 |                 |
        |    |                  |  about the non-t |                 |                 |
        |    |                  | echnical stuff t |                 |                 |
        |    |                  | hat goes into be |                 |                 |
        |    |                  | ing a great soft |                 |                 |
        |    |                  | ware developer.  |                 |                 |
        +----+------------------+------------------+-----------------+-----------------+
        |  2 | Akitando         | Conteúdo complem | https://www.fab | https://podcast |
        |    |                  | entar ao canal d | io.com/feed.xml | ers.spotify.com |
        |    |                  | e YouTube! "Akit |                 | /pod/show/akita |
        |    |                  | ando"            |                 | ndo             |
        +----+------------------+------------------+-----------------+-----------------+
      OUTPUT

      result = TestHelpers::CLI.run_cmd("pod podcasts")

      expect(result).to eq(expected_output.chomp)
    end

    context "when the fields parameter is used" do
      it "returns the podcast records, but only the selected fields" do
        expected_output = <<~OUTPUT
          +-------------------------+--------------------------------------------------+
          |           name          |                      website                     |
          +-------------------------+--------------------------------------------------+
          | Soft Skills Engineering | https://softskills.audio/                        |
          +-------------------------+--------------------------------------------------+
          | Akitando                | https://podcasters.spotify.com/pod/show/akitando |
          +-------------------------+--------------------------------------------------+
        OUTPUT

        result = TestHelpers::CLI.run_cmd("pod podcasts --fields=name website")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end
end
