
class Notifications < ActionMailer::Base
  def forgot_password(to, identity, pass, sent_at = Time.now)
    @subject          = "Your password is ..."
    @body['identity'] = identity
    @body['pass']     = pass
    @recipients       = to
    @from             = 'support@mygtfo.com'
    @sent_on          = sent_at
    @headers          = {}
  end
end
