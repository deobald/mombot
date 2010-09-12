require 'factory_girl'

Factory.define :pez do |p|
  p.sequence(:identity) {|n| "china#{n}" }
  p.colour   'aqua'
  p.status   'seated'
  p.priority 1
end

Factory.define :dispensed_pez, :class => Pez do |p|
  p.sequence(:identity) {|n| "china#{n}" }
  p.colour      'aqua'
  p.priority    1
  p.secret_code 'abcdef123456abcdef123456'
  p.after_create { |after| after.change_state_to 'dispensed' }
end

Factory.define :user do |u|
  u.sequence(:identity) {|n| "russia#{n}" }
  u.admin                 false
  u.name                  'Russia McPrussia'
  u.hashed_password       '77a0d943cdbace52716a9ef9fae12e45e2788d39' # test
  u.password              'test'
  u.password_confirmation 'test'
  u.sequence(:email) {|n| "russia#{n}@earth.com" }
  u.salt                  '1000'
  u.secret_code           'abcdef123456abcdef123456'
  u.after_build { |after| Factory :dispensed_pez, :identity => after.identity }
end

Factory.define :vote do |v|
  v.association :pez
  v.association :user
  v.approve     false
end

Factory.define :thing do |t|
  t.title "peninsula, cheap!"
  t.body  "75% border water... how could you go wrong?"
end

# specialized factories:

Factory.define :bob, :class => User do |b|
  b.identity              'bob'
  b.admin                 false
  b.name                  'Bob McBob'
  b.password              'test'
  b.password_confirmation 'test'
  b.email                 'bob@mcbob.com'
  b.secret_code           'abcdef123456abcdef123456'
end

Factory.define :longbob, :class => User do |b|
  b.identity              'longbob'
  b.admin                 false
  b.name                  'Longbob McBob'
  b.password              'longtest'
  b.password_confirmation 'longtest'
  b.email                 'lbob@mcbob.com'
  b.secret_code           'abcdef123456abcdef123456'
end

Factory.define :existingbob, :class => User do |b|
  b.identity              'existingbob'
  b.admin                 false
  b.name                  'Exbob McBob'
  b.password              'test'
  b.password_confirmation 'test'
  b.email                 'exbob@mcbob.com'
  b.secret_code           'abcdef123456abcdef123456'
  b.after_build { |after| Factory :dispensed_pez, :identity => after.identity }
end
