# coding: utf-8

unless User.exists?(email: 'admin@example.com')
  User.create!(email: 'admin@example.com', password: 'shallontec01', password_confirmation: 'shallontec01')
end

