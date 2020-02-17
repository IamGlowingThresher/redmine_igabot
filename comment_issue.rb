class CommentIssue
  class AcceptanceIssue
    def comment_issue(days_on)
      if days_on >= 12 && days_on < 14 && status == "acceptance"
        IssueComment.new(Messages::SoonClosedMessage.new)
      elsif days_on >= 14
        IssueComment.new(Messages::NowClosedMessage.new)
      end
    end
  end

  class ApprobationIssue
    def comment_issue(days_on)
      if days_on >= 30 && status == "approbation"
        IssueComment.new(Messages::LongApprobationMessage.new)
      end
    end
  end

  class EvaluationIssue
    def comment_issue(evaluation)
      if evaluation == 'bad'
        IssueComment.new(Messages::UsersEvaluationMessage.new)
      end
    end
  end
end