
require "#{RAILS_ROOT}/lib/extensions/string"

module UsersHelper
  
  def yes_no
    @approve ? 'yes' : 'no'
  end
  
  def user
    session[:user]
  end
  
  def new_candy
    user.dispenser
  end
  
  def status_link pez
    pez.votable? ? active_status_link(pez) : pez.identity
  end
  
  def active_status_link pez
    link_to pez.identity, :controller => 'pezez', :action => 'show', :id => pez.id
  end
  
  def vote_link pez, yes_or_no
    pez.votable? ? active_vote_link(pez, yes_or_no) : yes_or_no
  end
  
  def active_vote_link pez, yes_or_no
    link_to_remote yes_or_no,
                   :update => 'new-candy', 
                   :url => { :action => 'vote', :pez_id => pez.id, :approve => yes_or_no.to_boolean }
  end
  
  def liked pez
    user.liked pez
  end
  
  def disliked pez
    user.disliked pez
  end
  
end