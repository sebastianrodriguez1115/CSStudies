# frozen_string_literal: true

# Objetivo: contar cuantas veces aparece cada palabra.
# Ejemplo: "ruby ruby rails" -> { "ruby" => 2, "rails" => 1 }

text = 'ruby rails ruby rack rails ruby'

def word_frequencies(text)
  text.split.tally
end

puts word_frequencies(text)
