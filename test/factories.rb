require 'factory_girl'

Factory.define :pez do |p|
  p.identity 'china'
  p.colour   'aqua'
  p.status   'seated'
  p.priority 1
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
end

Factory.define :vote do |v|
  v.association :pez
  v.association :user
  v.approve     false
end

# specialized factories:

Factory.define :bob, :class => User do |b|
  b.identity              'bob'
  b.admin                 false
  b.name                  'Bob McBob'
  b.password              'test'
  b.password_confirmation 'test'
  b.email                 'bob@mcbob.com'
end

Factory.define :longbob, :class => User do |b|
  b.identity              'longbob'
  b.admin                 false
  b.name                  'Longbob McBob'
  b.password              'longtest'
  b.password_confirmation 'longtest'
  b.email                 'lbob@mcbob.com'
end

Factory.define :existingbob, :class => User do |b|
  b.identity              'existingbob'
  b.admin                 false
  b.name                  'Exbob McBob'
  b.password              'test'
  b.password_confirmation 'test'
  b.email                 'exbob@mcbob.com'
end
