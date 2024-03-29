# frozen_string_literal: true

require_relative "../support/test_helpers"

RSpec.describe Podrb::CLI do
  describe "input interpretation", :init_podrb do
    context "when the input is invalid" do
      it "tells the user that the command was not found" do
        result = TestHelpers::CLI.run_cmd("podrb invalid")

        expect(result).to eq('Could not find command "invalid".')
      end
    end
  end

  describe "init ensuring" do
    it "returns an error message when user tries to run podrb without initialization" do
      expected_output = <<~OUTPUT
        Missing config files. Run `podrb init` first.
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb podcasts")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "version command" do
    it "returns the podrb version" do
      original_result = TestHelpers::CLI.run_cmd("podrb version")
      alias_result1 = TestHelpers::CLI.run_cmd("podrb -V")
      alias_result2 = TestHelpers::CLI.run_cmd("podrb --version")

      expect(original_result).to eq(Podrb::VERSION)
      expect(alias_result1).to eq(original_result)
      expect(alias_result2).to eq(original_result)
    end
  end

  describe "init command" do
    it "creates the initial config files" do
      expected_output = <<~OUTPUT
        Creating config files...
        Podrb successfully initialized!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb init")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "add command", :init_podrb do
    it "adds a podcast to the podrb database" do
      podcast_feed = "spec/fixtures/soft_skills_engineering.xml"
      expected_output = <<~OUTPUT
        Adding the podcast...
        Podcast successfully added to the database!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb add #{podcast_feed}")

      expect(result).to eq(expected_output.chomp)
    end

    context "when the --sync-url option is used" do
      it "adds a podcast to the podrb database" do
        podcast_feed = "spec/fixtures/fabio_akita.xml"
        sync_url = "https://www.fabio.com/feed.xml"
        expected_output = <<~OUTPUT
          Adding the podcast...
          Podcast successfully added to the database!
        OUTPUT

        result = TestHelpers::CLI.run_cmd("podrb add #{podcast_feed} --sync-url=#{sync_url}")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end

  describe "podcasts command", :init_podrb, :populate_db do
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

      result = TestHelpers::CLI.run_cmd("podrb podcasts")

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

        result = TestHelpers::CLI.run_cmd("podrb podcasts --fields=name website")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end

  describe "episodes command", :init_podrb, :populate_db do
    it "returns the podcast episodes" do
      expected_output = <<~OUTPUT
        +----+--------------------+--------------------+----------+--------------------+
        | id |        title       |    release_date    | duration |        link        |
        +----+--------------------+--------------------+----------+--------------------+
        |  1 | Episode 1: Startup | 2016-03-07T19:00:0 | 25:33    | https://softskills |
        |    |  Opportunities and | 0Z                 |          | .audio/2016/03/07/ |
        |    |  Switching Jobs    |                    |          | episode-1-startup- |
        |    |                    |                    |          | opportunities-and- |
        |    |                    |                    |          | switching-jobs/    |
        +----+--------------------+--------------------+----------+--------------------+
        |  2 | Episode 2: Influen | 2016-03-14T19:00:0 | 25:33    | https://softskills |
        |    | cing your team and | 0Z                 |          | .audio/2016/03/14/ |
        |    |  dealing with ange |                    |          | episode-2-influenc |
        |    | r                  |                    |          | ing-your-team-and- |
        |    |                    |                    |          | dealing-with-anger |
        |    |                    |                    |          | /                  |
        +----+--------------------+--------------------+----------+--------------------+
        |  3 | Episode 3: What to | 2016-03-21T19:00:0 | 25:33    | https://softskills |
        |    |  look for in a dev | 0Z                 |          | .audio/2016/03/21/ |
        |    |  team              |                    |          | episode-3-what-to- |
        |    |                    |                    |          | look-for-in-a-dev- |
        |    |                    |                    |          | team/              |
        +----+--------------------+--------------------+----------+--------------------+
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb episodes 1")

      expect(result).to eq(expected_output.chomp)
    end

    context "when the fields parameter is used" do
      it "returns the podcast episodes, but only the selected fields" do
        expected_output = <<~OUTPUT
          +---------------------------------------+--------------------------------------+
          |                 title                 |                 link                 |
          +---------------------------------------+--------------------------------------+
          | Episode 1: Startup Opportunities and  | https://softskills.audio/2016/03/07/ |
          | Switching Jobs                        | episode-1-startup-opportunities-and- |
          |                                       | switching-jobs/                      |
          +---------------------------------------+--------------------------------------+
          | Episode 2: Influencing your team and  | https://softskills.audio/2016/03/14/ |
          | dealing with anger                    | episode-2-influencing-your-team-and- |
          |                                       | dealing-with-anger/                  |
          +---------------------------------------+--------------------------------------+
          | Episode 3: What to look for in a dev  | https://softskills.audio/2016/03/21/ |
          | team                                  | episode-3-what-to-look-for-in-a-dev- |
          |                                       | team/                                |
          +---------------------------------------+--------------------------------------+
        OUTPUT

        result = TestHelpers::CLI.run_cmd("podrb episodes 1 --fields=title link")

        expect(result).to eq(expected_output.chomp)
      end
    end

    context "when the order_by parameter is used" do
      it "returns the podcast episodes, but using the chosed order" do
        expected_output = <<~OUTPUT
          +----+---------------------------------------------------------+
          | id |                          title                          |
          +----+---------------------------------------------------------+
          |  3 | Episode 3: What to look for in a dev team               |
          +----+---------------------------------------------------------+
          |  2 | Episode 2: Influencing your team and dealing with anger |
          +----+---------------------------------------------------------+
          |  1 | Episode 1: Startup Opportunities and Switching Jobs     |
          +----+---------------------------------------------------------+
        OUTPUT

        result = TestHelpers::CLI.run_cmd("podrb episodes 1 --fields=id title --order-by='id desc'")

        expect(result).to eq(expected_output.chomp)
      end
    end

    context "when there are archived episodes, but the --all option is used" do
      it "returns all the podcast episodes" do
        expected_output = <<~OUTPUT
          +----+---------------------------------------------------------+
          | id |                          title                          |
          +----+---------------------------------------------------------+
          |  1 | Episode 1: Startup Opportunities and Switching Jobs     |
          +----+---------------------------------------------------------+
          |  2 | Episode 2: Influencing your team and dealing with anger |
          +----+---------------------------------------------------------+
          |  3 | Episode 3: What to look for in a dev team               |
          +----+---------------------------------------------------------+
        OUTPUT

        TestHelpers::CLI.run_cmd("podrb archive 1")
        result = TestHelpers::CLI.run_cmd("podrb episodes 1 --fields=id title --all")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end

  describe "archive command", :init_podrb, :populate_db do
    it "archives the episode" do
      expected_output = <<~OUTPUT
        Episode successfully archived!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb archive 1")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "dearchive command", :init_podrb, :populate_db do
    it "dearchives the episode" do
      expected_output = <<~OUTPUT
        Episode successfully dearchived!
      OUTPUT

      TestHelpers::CLI.run_cmd("podrb archive 1")
      result = TestHelpers::CLI.run_cmd("podrb dearchive 1")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "delete command", :init_podrb, :populate_db do
    it "deletes the podcast" do
      expected_output = <<~OUTPUT
        Podcast successfully deleted!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb delete 1")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "update command", :init_podrb, :populate_db do
    it "updated the podcast" do
      expected_output = <<~OUTPUT
        Podcast successfully updated!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("podrb update 1 --feed=https://www.newfeed.com")

      expect(result).to eq(expected_output.chomp)
    end
  end
end
