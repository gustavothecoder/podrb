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

  describe "episodes command", :init_pod, :populate_db do
    it "returns the podcast episodes" do
      result = TestHelpers::CLI.run_cmd("pod episodes 1")

      expect(result).to eq(soft_skills_engineering_episodes_text_output.chomp)
    end

    context "when the fields parameter is used" do
      it "returns the podcast records, but only the selected fields" do
        expected_output = <<~OUTPUT
          +---------------------------------------+--------------------------------------+
          |                 title                 |                 link                 |
          +---------------------------------------+--------------------------------------+
          | Episode 3: What to look for in a dev  | https://softskills.audio/2016/03/21/ |
          | team                                  | episode-3-what-to-look-for-in-a-dev- |
          |                                       | team/                                |
          +---------------------------------------+--------------------------------------+
          | Episode 2: Influencing your team and  | https://softskills.audio/2016/03/14/ |
          | dealing with anger                    | episode-2-influencing-your-team-and- |
          |                                       | dealing-with-anger/                  |
          +---------------------------------------+--------------------------------------+
          | Episode 1: Startup Opportunities and  | https://softskills.audio/2016/03/07/ |
          | Switching Jobs                        | episode-1-startup-opportunities-and- |
          |                                       | switching-jobs/                      |
          +---------------------------------------+--------------------------------------+
        OUTPUT

        result = TestHelpers::CLI.run_cmd("pod episodes 1 --fields=title link")

        expect(result).to eq(expected_output.chomp)
      end
    end
  end

  private

  # TODO: remove HTML
  def soft_skills_engineering_episodes_text_output
    <<~OUTPUT
      +----------------+----------------+----------+----------------+----------------+
      |      title     |  release_date  | duration |   description  |      link      |
      +----------------+----------------+----------+----------------+----------------+
      | Episode 3: Wha | 2016-03-21T19: | 25:33    | <p>In episode  | https://softsk |
      | t to look for  | 00:00Z         |          | 3, Jamison and | ills.audio/201 |
      | in a dev team  |                |          |  Dave answer t | 6/03/21/episod |
      |                |                |          | wo questions:< | e-3-what-to-lo |
      |                |                |          | /p>            | ok-for-in-a-de |
      |                |                |          |                | v-team/        |
      |                |                |          | <ol>           |                |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>What sh |                |
      |                |                |          | ould I look fo |                |
      |                |                |          | r in a dev tea |                |
      |                |                |          | m?</p>         |                |
      |                |                |          |   </li>        |                |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>I don’t |                |
      |                |                |          |  get enough do |                |
      |                |                |          | ne at work. I  |                |
      |                |                |          | work on a smal |                |
      |                |                |          | l team that ha |                |
      |                |                |          | s aggressive p |                |
      |                |                |          | lans for devel |                |
      |                |                |          | oping its prod |                |
      |                |                |          | uct, but I don |                |
      |                |                |          | ’t feel like I |                |
      |                |                |          |  get enough wo |                |
      |                |                |          | rk done or mov |                |
      |                |                |          | e fast enough  |                |
      |                |                |          | for the compan |                |
      |                |                |          | y.</p>         |                |
      |                |                |          |   </li>        |                |
      |                |                |          | </ol>          |                |
      |                |                |          |                |                |
      |                |                |          |                |                |
      +----------------+----------------+----------+----------------+----------------+
      | Episode 2: Inf | 2016-03-14T19: | 25:33    | <p>In episode  | https://softsk |
      | luencing your  | 00:00Z         |          | 2, Jamison and | ills.audio/201 |
      | team and deali |                |          |  Dave answer t | 6/03/14/episod |
      | ng with anger  |                |          | wo questions:< | e-2-influencin |
      |                |                |          | /p>            | g-your-team-an |
      |                |                |          |                | d-dealing-with |
      |                |                |          | <ol>           | -anger/        |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>I work  |                |
      |                |                |          | on a team, and |                |
      |                |                |          |  I am not the  |                |
      |                |                |          | team lead. I h |                |
      |                |                |          | ave lots of id |                |
      |                |                |          | eas for how to |                |
      |                |                |          |  do things bet |                |
      |                |                |          | ter. How can I |                |
      |                |                |          |  influence my  |                |
      |                |                |          | team without b |                |
      |                |                |          | eing the team  |                |
      |                |                |          | lead, or witho |                |
      |                |                |          | ut stepping on |                |
      |                |                |          |  his or her sh |                |
      |                |                |          | oes?</p>       |                |
      |                |                |          |   </li>        |                |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>How do  |                |
      |                |                |          | you deal with  |                |
      |                |                |          | anger at work, |                |
      |                |                |          |  both on the r |                |
      |                |                |          | eceiving and g |                |
      |                |                |          | iving end?</p> |                |
      |                |                |          |   </li>        |                |
      |                |                |          | </ol>          |                |
      |                |                |          |                |                |
      |                |                |          |                |                |
      +----------------+----------------+----------+----------------+----------------+
      | Episode 1: Sta | 2016-03-07T19: | 25:33    | <p>Welcome to  | https://softsk |
      | rtup Opportuni | 00:00Z         |          | Soft Skills En | ills.audio/201 |
      | ties and Switc |                |          | gineering, whe | 6/03/07/episod |
      | hing Jobs      |                |          | re we answer y | e-1-startup-op |
      |                |                |          | our questions  | portunities-an |
      |                |                |          | about non-tech | d-switching-jo |
      |                |                |          | nical topics i | bs/            |
      |                |                |          | n software eng |                |
      |                |                |          | ineering. Come |                |
      |                |                |          |  get some wisd |                |
      |                |                |          | om, or at leas |                |
      |                |                |          | t some wise cr |                |
      |                |                |          | acks.</p>      |                |
      |                |                |          |                |                |
      |                |                |          | <p>In episode  |                |
      |                |                |          | 1, Dave and Ja |                |
      |                |                |          | mison answer t |                |
      |                |                |          | wo questions:< |                |
      |                |                |          | /p>            |                |
      |                |                |          |                |                |
      |                |                |          | <ol>           |                |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>I’m a d |                |
      |                |                |          | eveloper who g |                |
      |                |                |          | ets approached |                |
      |                |                |          |  from time to  |                |
      |                |                |          | time to work o |                |
      |                |                |          | n new software |                |
      |                |                |          |  ideas. While  |                |
      |                |                |          | I find working |                |
      |                |                |          |  on something  |                |
      |                |                |          | new and intrig |                |
      |                |                |          | uing I have no |                |
      |                |                |          |  experience wi |                |
      |                |                |          | th business. H |                |
      |                |                |          | ow do I determ |                |
      |                |                |          | ine how legiti |                |
      |                |                |          | mate these opp |                |
      |                |                |          | ortunities are |                |
      |                |                |          | ?</p>          |                |
      |                |                |          |   </li>        |                |
      |                |                |          |   <li>         |                |
      |                |                |          |     <p>At my c |                |
      |                |                |          | urrent job, ou |                |
      |                |                |          | r codebase is  |                |
      |                |                |          | a few years ol |                |
      |                |                |          | d and we use a |                |
      |                |                |          | n “older” java |                |
      |                |                |          | script framewo |                |
      |                |                |          | rk. In my spar |                |
      |                |                |          | e time I’ve re |                |
      |                |                |          | ally really en |                |
      |                |                |          | joyed using on |                |
      |                |                |          | e of the newer |                |
      |                |                |          |  paradigms and |                |
      |                |                |          |  technical sta |                |
      |                |                |          | cks and I wish |                |
      |                |                |          |  I had more op |                |
      |                |                |          | portunity to g |                |
      |                |                |          | et experience  |                |
      |                |                |          | with these tec |                |
      |                |                |          | hnologies. I d |                |
      |                |                |          | on’t see a rew |                |
      |                |                |          | rite or even a |                |
      |                |                |          |  migration any |                |
      |                |                |          |  time soon for |                |
      |                |                |          |  our codebase  |                |
      |                |                |          | at this compan |                |
      |                |                |          | y and have bee |                |
      |                |                |          | n considering  |                |
      |                |                |          | taking a job w |                |
      |                |                |          | here I’d have  |                |
      |                |                |          | opportunity to |                |
      |                |                |          |  work with the |                |
      |                |                |          | se newer techn |                |
      |                |                |          | ologies. This  |                |
      |                |                |          | despite enjoyi |                |
      |                |                |          | ng my coworker |                |
      |                |                |          | s, and lacking |                |
      |                |                |          |  any major com |                |
      |                |                |          | plaints at thi |                |
      |                |                |          | s company. On  |                |
      |                |                |          | a scale from 1 |                |
      |                |                |          |  to 10 how cra |                |
      |                |                |          | zy am I for co |                |
      |                |                |          | nsidering a jo |                |
      |                |                |          | b change?</p>  |                |
      |                |                |          |   </li>        |                |
      |                |                |          | </ol>          |                |
      |                |                |          |                |                |
      |                |                |          |                |                |
      +----------------+----------------+----------+----------------+----------------+
    OUTPUT
  end
end
