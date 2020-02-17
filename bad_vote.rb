require 'time'

STUB_DAYS_BEING_BAD = 22

class BadVote
  def time_correct?(j)
    true unless ((Time.now - Time.strptime(j['created_on'], '%Y-%m-%d')).to_i / (60 * 60 * 24)) > STUB_DAYS_BEING_BAD
  end

  def initialize(j)
    j['details'].each do |d|
      if d['name'] == 'vote' && d['new_value'] == '0' && time_correct?(j)
        @task_is_bad = true
      end
    end
  end

  attr_reader :task_is_bad
end
