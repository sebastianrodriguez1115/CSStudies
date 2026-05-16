# frozen_string_literal: true

# Objetivo: convertir textos legibles en slugs simples.
# Ejemplo: "Ruby Foundations" -> "ruby-foundations"

titles = [
  'Ruby Foundations',
  'Blocks and Enumerable',
  'HTTP and Rack basics'
]

def slugify(text)
  text.downcase.split.join('-')
end

slugs = titles.map { |title| slugify(title) }

puts slugs
