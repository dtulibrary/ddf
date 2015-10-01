module PagesHelper
   def format_pct(pct)
    ["(", "#{pct}", "%", ")"].join
  end
end
