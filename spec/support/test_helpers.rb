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
          link: "https://softskills.audio/2016/03/21/episode-3-what-to-look-for-in-a-dev-team/"
        },
        {
          title: "Episode 2: Influencing your team and dealing with anger",
          release_date: "2016-03-14T19:00:00Z",
          duration: "25:33",
          link: "https://softskills.audio/2016/03/14/episode-2-influencing-your-team-and-dealing-with-anger/"
        },
        {
          title: "Episode 1: Startup Opportunities and Switching Jobs",
          release_date: "2016-03-07T19:00:00Z",
          duration: "25:33",
          link: "https://softskills.audio/2016/03/07/episode-1-startup-opportunities-and-switching-jobs/"
        }
      ]
    end

    def fabio_akita
      {
        name: "Akitando",
        description: "Conteúdo complementar ao canal de YouTube! \"Akitando\"",
        feed: "https://www.fabio.com/feed.xml",
        website: "https://podcasters.spotify.com/pod/show/akitando"
      }
    end

    def fabio_akita_episodes
      [
        {
          title: "Akitando #0002 - Akitando em Seoul - Parte 2",
          release_date: "2020-02-20T00:31:00Z",
          duration: "00:10:55",
          link: "https://podcasters.spotify.com/pod/show/akitando/episodes/Akitando-0002---Akitando-em-Seoul---Parte-2-eaundj"
        },
        {
          title: "Akitando #0001 - Akitando em Seoul - Parte 1",
          release_date: "2020-02-20T00:26:23Z",
          duration: "00:09:38",
          link: "https://podcasters.spotify.com/pod/show/akitando/episodes/Akitando-0001---Akitando-em-Seoul---Parte-1-eaunab"
        },
        {
          title: "Akitando - Piloto",
          release_date: "2020-02-20T00:01:49Z",
          duration: "00:00:34",
          link: "https://podcasters.spotify.com/pod/show/akitando/episodes/Akitando---Piloto-eaumu2"
        }
      ]
    end
  end
end
