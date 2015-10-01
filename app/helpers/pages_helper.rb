module PagesHelper
   def format_as_pct(value)
    ["#{value}", "%"].join
  end
   def parenthesize_as_pct(value)
    ["(", format_as_pct(value), ")"].join
  end
end
