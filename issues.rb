require 'httparty'

class Issues
  def initialize(project_id, status_id=nil)
    @issues = get_issues(project_id, status_id)
  end

  def issues
    @issues
  end
  def get_issues(prj, stid=nil, offset = 0)
    akey = '2814a2f2fa27477c8afaa33ab73a2ebfc583544b'
    issue_list = []
    host = 'http://192.168.1.248:9000/redmine'
    path_prj = "/issues.json?key=#{akey}&project_id=#{prj}&status_id=#{stid}&limit=100&offset=#{offset}" unless stid.nil?
    path_prj = "/issues.json?key=#{akey}&project_id=#{prj}&limit=100&offset=#{offset}" if stid.nil?
    pp = HTTParty.get(host + path_prj).parsed_response
    pp1 = pp['issues']
    pp1.each do |issue|
      issue_list << issue['id']
    end
    if pp['total_count'] > issue_list.length
      offset += 100
      get_issues(prj, stid, offset)
    end
    issue_list
  end

end