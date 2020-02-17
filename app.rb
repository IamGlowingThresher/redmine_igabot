require_relative 'issues'
require_relative 'journals_by_issue'
require_relative 'bad_vote'
require_relative 'browser_actions'
require 'time'
require 'selenium-webdriver'
require 'terminal-table'
require 'terminal'

WEAK_LIMIT_ACCEPTANCE=12
CLOSING_LIMIT_ACCEPTANCE=14
LIMIT_APPROBATION=30

STUB_WEAK_LIMIT_ACCEPTANCE=2
STUB_CLOSING_LIMIT_ACCEPTANCE=77
STUB_LIMIT_APPROBATION=0

L2_TEST_PROJECT = 83

APPROBATION_STATUS = 3
ACCEPTANCE_STATUS = 9
STUB_STATUS_1 = 4
STUB_STATUS_2 = 4

HOST = 'http://192.168.1.248:9000/redmine'

def format_time(time)
  begin
    Time.parse(time)
  rescue ArgumentError
    Time.strptime(time, "%m/%d/%Y")
  end
end



acceptance_issues = Issues.new(project_id=L2_TEST_PROJECT, status_id=STUB_STATUS_1)
approbation_issues = Issues.new(project_id=L2_TEST_PROJECT, status_id=STUB_STATUS_2)
evaluation_issues = Issues.new(project_id=L2_TEST_PROJECT)

p 'ACCEPT'
options = Selenium::WebDriver::Firefox::Options.new(args: [])
driver = Selenium::WebDriver.for :firefox, options: options
path = "/issues/2543"
host = HOST
driver.navigate.to host + path
BrowserActions.auth driver

acceptance_issues.issues.each do |issue_id|
  host = 'http://192.168.1.248:9000/redmine'
  path_stt = "/issues/#{issue_id}/status"
  driver.navigate.to host + path_stt
  if driver.title == 'Тест. IGA Projects Tracker'
    driver.find_element(xpath: '//input[@type="text"]').clear
    driver.find_element(xpath: '//input[@type="text"]').send_keys("igabot")
    driver.find_element(xpath: '//input[@type="password"]').clear
    driver.find_element(xpath: '//input[@type="password"]').send_keys("YPVfB1nU")
    element1 = driver.find_element(xpath: '//input[@type="submit"]')
    driver.execute_script("arguments[0].click()", element1)
  end
  sleep 2
  time_change = driver.find_element(css: 'tbody tr:last-child td:nth-child(2)').text
  time_change_formatted = format_time(time_change)
  duration = (Time.now - time_change_formatted).to_i / (60 * 60 * 24)
  if duration > 12
    p ["http://192.168.1.248:9000/redmine/issues/#{issue_id}", "#{duration} д."]
  end
end
driver.quit
p 'APPROB'
options1 = Selenium::WebDriver::Firefox::Options.new(args: [])
driver1 = Selenium::WebDriver.for :firefox, options: options1
path1 = "/issues/2529/"
host1 = 'http://192.168.1.248:9000/redmine'
driver1.navigate.to host1 + path1
driver1.find_element(xpath: '//input[@type="text"]').clear
driver1.find_element(xpath: '//input[@type="text"]').send_keys("igabot")
driver1.find_element(xpath: '//input[@type="password"]').clear
driver1.find_element(xpath: '//input[@type="password"]').send_keys("YPVfB1nU")
element1 = driver1.find_element(xpath: '//input[@type="submit"]')
driver1.execute_script("arguments[0].click()", element1)

approbation_issues.issues.each do |issue_id|
  host1 = HOST
  path_stt1 = "/issues/#{issue_id}/status"
  driver1.navigate.to host1 + path_stt1
  if driver1.title == 'Тест. IGA Projects Tracker'
    driver1.find_element(xpath: '//input[@type="text"]').clear
    driver1.find_element(xpath: '//input[@type="text"]').send_keys("igabot")
    driver1.find_element(xpath: '//input[@type="password"]').clear
    driver1.find_element(xpath: '//input[@type="password"]').send_keys("YPVfB1nU")
    element1 = driver1.find_element(xpath: '//input[@type="submit"]')
    driver1.execute_script("arguments[0].click()", element1)
  end
  sleep 2
  time_change1 = driver1.find_element(css: 'tbody tr:last-child td:nth-child(2)').text
  time_change_formatted1 = format_time(time_change1)
  duration1 = (Time.now - time_change_formatted1).to_i / (60 * 60 * 24)
  if duration1 > STUB_LIMIT_APPROBATION
    p ["http://192.168.1.248:9000/redmine/issues/#{issue_id}", "#{duration1} д."]
  end
end
driver1.quit
#
#Thread.new do
#  approbation_issues.issues.each do |app_issue|
#    app_issue
#  end
#end
#
evaluation_issues.issues.each do |eva_issue|
  JournalsByIssue.new(eva_issue).journals.each { |journal|
    if BadVote.new(journal).task_is_bad
      p ["http://192.168.1.248:9000/redmine/issues/#{eva_issue}", "BAD TOO BAD д."]
    end
  }
end