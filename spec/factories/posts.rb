FactoryGirl.define do
  factory :post do
    sequence(:title) {|n| "Janz wischsch #{n}"}
    text 'A blasphemical <blockquote>shortnovela</blockquote> with enormouslargely fantasywords.'
    lang 'en_uk'
    trait :american do
      lang 'en_us'
    end
    trait :german do
      text 'Ein blasphemischer Kurzroman mit riesenlangen Fantasiewörtern.'
      lang 'de1'
    end
    # fake traits to urge factory_girl to return a new instance:
    (1..5).each {|n| trait "var#{n}".to_sym }
  end
end
