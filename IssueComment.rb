require_relative 'messages'
require_relative 'browser_actions'

EDIT_BUTTON = {css: '#content > div:nth-child(1) > a.icon.icon-edit'}
HOST = "https://redmine.igatec.com/redmine"

class IssueComment
  def initialize(issue, message)
    web = BrowserActions.new
    web.navigate_to("https://redmine.igatec.com/redmine/issues/#{issue}")
    web.auth
    web.click_at_elem({css: '#content > div:nth-child(6) > a.icon.icon-edit'})
    sleep 1
    iframe = web.get_iframe(css: '#cke_2_contents > iframe')
    web.switch_to_frame(iframe)
    web.send_keys_to_elem({css: 'body'}, message)
    web.switch_back
    web.click_at_elem(css: '#issue-form > input:nth-child(7)')
  end
end

IssueComment.new(4610, 'auto message')
IssueComment.new(4610, Messages::SoonClosedMessage.new.msg)