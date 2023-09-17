# frozen_string_literal: true

require "open3"

module TestHelpers
  module CLI
    def self.run_cmd(cmd)
      stdout, stderr, _ = Open3.capture3(cmd)

      (stdout.empty? ? stderr : stdout).chomp
    end
  end

  module Path
    extend self

    def config_dir
      home_dir = ENV["HOME"]
      return "" if home_dir.nil?

      home_dir + "/.config/pod"
    end

    def db_dir
      config_dir + "/pod.db"
    end
  end

  module Data
    extend self

    def soft_skills_engineering
      {
        name: "Soft Skills Engineering",
        description: "It takes more than great code to be a great engineer. " \
                     "Soft Skills Engineering is a weekly advice podcast for software developers " \
                     "about the non-technical stuff that goes into being a great software developer.",
        feed: "https://softskills.audio/feed.xml",
        website: "https://softskills.audio/"
      }
    end

    def soft_skills_engineering_episodes
      [
        {
          title: "Episode 3: What to look for in a dev team",
          release_date: "2016-03-21T19:00:00Z",
          duration: "25:33",
          description: "<p>In episode 3, Jamison and Dave answer two questions:</p>\n\n<ol>\n  <li>\n    <p>What should I look for in a dev team?</p>\n  </li>\n  <li>\n    <p>I don’t get enough done at work. I work on a small team that has aggressive plans for developing its product, but I don’t feel like I get enough work done or move fast enough for the company.</p>\n  </li>\n</ol>\n\n",
          link: "https://softskills.audio/2016/03/21/episode-3-what-to-look-for-in-a-dev-team/"
        },
        {
          title: "Episode 2: Influencing your team and dealing with anger",
          release_date: "2016-03-14T19:00:00Z",
          duration: "25:33",
          description: "<p>In episode 2, Jamison and Dave answer two questions:</p>\n\n<ol>\n  <li>\n    <p>I work on a team, and I am not the team lead. I have lots of ideas for how to do things better. How can I influence my team without being the team lead, or without stepping on his or her shoes?</p>\n  </li>\n  <li>\n    <p>How do you deal with anger at work, both on the receiving and giving end?</p>\n  </li>\n</ol>\n\n",
          link: "https://softskills.audio/2016/03/14/episode-2-influencing-your-team-and-dealing-with-anger/"
        },
        {
          title: "Episode 1: Startup Opportunities and Switching Jobs",
          release_date: "2016-03-07T19:00:00Z",
          duration: "25:33",
          description: "<p>Welcome to Soft Skills Engineering, where we answer your questions about non-technical topics in software engineering. Come get some wisdom, or at least some wise cracks.</p>\n\n<p>In episode 1, Dave and Jamison answer two questions:</p>\n\n<ol>\n  <li>\n    <p>I’m a developer who gets approached from time to time to work on new software ideas. While I find working on something new and intriguing I have no experience with business. How do I determine how legitimate these opportunities are?</p>\n  </li>\n  <li>\n    <p>At my current job, our codebase is a few years old and we use an “older” javascript framework. In my spare time I’ve really really enjoyed using one of the newer paradigms and technical stacks and I wish I had more opportunity to get experience with these technologies. I don’t see a rewrite or even a migration any time soon for our codebase at this company and have been considering taking a job where I’d have opportunity to work with these newer technologies. This despite enjoying my coworkers, and lacking any major complaints at this company. On a scale from 1 to 10 how crazy am I for considering a job change?</p>\n  </li>\n</ol>\n\n",
          link: "https://softskills.audio/2016/03/07/episode-1-startup-opportunities-and-switching-jobs/"
        }
      ]
    end
  end
end
