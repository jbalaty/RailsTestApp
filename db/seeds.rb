# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Ad.delete_all

Ad.create!(title: 'Prodej, byt 4+1, 144 m²',
           description: %{Dva objekty malobytových vil s terasovými apartmány - prostorné byty 2+kk až 6+1
(užitná plocha 45 až 220 m2) s velikými terasami či terasovými travními zahradami nebo zahradami na terénu pozemku -
nabízejí excelentní výhled do údolí Radotína a řeky Berounky. Všechny byty i terasy jsou orientovány na jih s celodenním
 osluněním Pro parkování jsou k dispozici velkoryse dimenzované podzemní garáže.},
          price:11_990_000,
          externsource:'sreality',
          externid:'4106',
          url:'http://www.sreality.cz/detail/prodej/byt/4+1/praha-praha-5-/4000535132?attractiveAdvertId=3459')


Request.delete_all
Request.create!(title:'Muj inzerat na barak 1',
                url:'http://www.sreality.cz/detail/prodej/byt/4+1/praha-praha-5-/4000535132?attractiveAdvertId=3459',
                email:'testemail@test.com'
)
Request.create!(title:'Muj inzerat na barak 2',
                url:'http://www.sreality.cz/detail/prodej/byt/2+kk/praha-zabehlice-pracska/4152259164',
                email:'testemail@test.com'
)
Request.create!(title:'Muj inzerat na byt 1',
                url:'http://www.sreality.cz/detail/prodej/byt/2+kk/praha-zlicin-vestonicka/1773867868',
                email:'testemail@test.com'
)
