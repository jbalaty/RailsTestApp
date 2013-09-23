class ChangeNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.change_notifier.SearchInfoChangeSummary.subject
  #
  def SearchInfoChangeSummary
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
