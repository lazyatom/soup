dynasnip "rand", <<-EOF
class RandomNumber
  def handle(min=1, max=100)
    # arguments come in as strings, so we need to convert them.
    min = min.to_i
    max = max.to_i
    (rand(max-min) + min)
  end
end
RandomNumber
EOF