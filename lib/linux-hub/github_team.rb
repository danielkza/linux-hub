module LinuxHub
  class GithubTeam
    def initialize(organisation:, team:)
      @org = organisation
      @team = team
    end

    def users
      @users ||= fetch_users
    end

    def team_id
      @team_id ||= fetch_team_id
    end

    private

    def fetch_users
      client.team_members(team_id).collect do |member|
        GithubUser.new(member.login)
      end
    end

    def fetch_team_id
      begin
        client.auto_paginate = true
        team = client.organization_teams(@org).find { |t| t[:name] == @team }
      ensure
        client.auto_paginate = false
      end

      fail "Could not find team #{@team}" if team.nil?
      team.id
    end

    def client
      Github.instance.client
    end
  end
end
